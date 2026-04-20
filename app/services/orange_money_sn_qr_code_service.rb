require 'net/http'
require 'net/http/digest_auth'
require 'uri'
require 'json'

# Handles Orange Money Sénégal QR Code payments via the TouchPay / gutouch API.
#
# API endpoint: PUT https://api.gutouch.com/dist/api/touchpayapi/v1/{PATH_ID}/transaction
# Service code: PAIEMENTMARCHANDOMQRCODE
# Auth: HTTP Digest with loginAgent/passwordAgent as query params.
#
# Flow:
#   1. App calls initiate_payment → API returns { qrCode (base64), deepLink, validity }
#   2. App displays QR code to user
#   3. User scans with Orange Money app and confirms
#   4. TouchPay POSTs result to callback URL (orange_money_sn_qrcode_payment_confirmation)
#   5. App confirms the contribution
#
# Required ENV variables (réutilisation des variables existantes prod-fiatope/kwendoo):
#   TOUCH_HOST                — e.g. https://api.gutouch.com
#   TOUCH_SN_PATH_ID          — agent/path ID (e.g. ASFAT14242)
#   TOUCH_SN_OM_LOGIN_API     — loginAgent query param (=697599242)
#   TOUCH_SN_OM_PASSWORD_API  — passwordAgent query param
#   TOUCH_SN_OM_USERNAME      — Digest auth username (SHA256 hex, 64 chars)
#   TOUCH_SN_OM_PASSWORD      — Digest auth password (SHA256 hex)
#   TOUCH_SN_OM_RECIPIENT_NUMBER — Numéro Orange Money du marchand (reçoit le paiement)
#                                  Seule nouvelle variable à ajouter en prod.
#
# Variable à mettre à jour en prod:
#   TOUCH_SN_OM_SERVICECODE   → doit valoir PAIEMENTMARCHANDOMQRCODE (pas PAIEMENTMARCHANDOM)
class OrangeMoneySnQrCodeService < ApplicationService
  include Rails.application.routes.url_helpers

  SERVICE_CODE = 'PAIEMENTMARCHANDOMQRCODE'.freeze

  attr_accessor :contribution

  def initialize(contribution)
    @contribution   = contribution
    @touch_host     = ENV['TOUCH_HOST']
    @path_id        = ENV['TOUCH_SN_PATH_ID']
    @login_api      = ENV['TOUCH_SN_OM_LOGIN_API']
    @password_api   = ENV['TOUCH_SN_OM_PASSWORD_API']
    @username       = ENV['TOUCH_SN_OM_USERNAME']
    @password       = ENV['TOUCH_SN_OM_PASSWORD']
    @recipient_num  = ENV['TOUCH_SN_OM_RECIPIENT_NUMBER']
    @partner_name   = 'Kwendoo'
  end

  def self.initialize_payment_for(contribution)
    new(contribution).initiate_payment
  end

  def initiate_payment
    id_from_client = "#{Time.now.to_i}#{contribution.id}"
    callback_url   = build_callback_url
    return_url     = build_return_url
    amount         = contribution.cfa_value.to_i

    data = {
      'idFromClient'   => id_from_client,
      'additionnalInfos' => {
        'recipientEmail'    => contribution.user.try(:email),
        'recipientFirstName'=> contribution.user.try(:name),
        'recipientLastName' => contribution.user.try(:name),
        # No 'destinataire' for QR code flow: the payer is identified by the QR scan, not a phone number.
        # 'destinataire' would be the payer's phone — we do not collect it here.
        'partner_name'      => @partner_name,
        'return_url'        => return_url,
        'cancel_url'        => return_url,
        'currency'          => 'XOF'
      },
      'amount'          => amount,
      'callback'        => callback_url,
      'recipientNumber' => @recipient_num,
      'serviceCode'     => SERVICE_CODE
    }

    Rails.logger.info "[OmSnQrCode] initiating QR payment for contribution=#{contribution.id} " \
                      "amount=#{amount} id_from_client=#{id_from_client}"

    response      = perform_digest_request(data)
    response_json = JSON.parse(response.body)

    Rails.logger.info "[OmSnQrCode] API response status=#{response_json['status']} " \
                      "idFromGU=#{response_json['idFromGU']} " \
                      "numTransaction=#{response_json['numTransaction']}"

    tx = contribution.orange_money_sn_qr_code_transactions.create!(
      id_from_client: id_from_client,
      id_from_gu:     response_json['idFromGU'],
      status:         response_json['status'],
      qr_code_base64: response_json['qrCode'],
      deep_link:      response_json['deepLink'] || response_json['OM'] || response_json['MAXIT'],
      validity:       response_json['validity'].to_s,
      service_code:   SERVICE_CODE
    )

    response_json.merge('transaction_db_id' => tx.id)
  rescue => e
    Rails.logger.error "[OmSnQrCode] initiate_payment failed: #{e.class} #{e.message}"
    raise
  end

  private

  def perform_digest_request(data)
    api_path = "/dist/api/touchpayapi/v1/#{@path_id}/transaction"
    full_url = "#{@touch_host}#{api_path}?loginAgent=#{@login_api}&passwordAgent=#{@password_api}"

    digest_uri          = URI.parse(full_url)
    digest_uri.user     = @username
    digest_uri.password = @password

    http              = Net::HTTP.new(digest_uri.host, digest_uri.port)
    http.use_ssl      = (digest_uri.scheme == 'https')
    http.verify_mode  = OpenSSL::SSL::VERIFY_NONE
    http.read_timeout = 30
    http.open_timeout = 15

    # Step 1 — unauthenticated GET to obtain the Digest challenge
    probe = Net::HTTP::Get.new(digest_uri.request_uri)
    probe['Accept']       = 'application/json'
    probe['Content-Type'] = 'application/json'
    challenge_response    = http.request(probe)

    # Step 2 — authenticated PUT with Digest header
    digest_auth = Net::HTTP::DigestAuth.new
    auth_header = digest_auth.auth_header(digest_uri, challenge_response['www-authenticate'], 'PUT')

    put_req                   = Net::HTTP::Put.new(digest_uri.request_uri)
    put_req.body              = data.to_json
    put_req['Accept']         = 'application/json'
    put_req['Content-Type']   = 'application/json'
    put_req.add_field 'Authorization', auth_header

    http.request(put_req)
  end

  def build_callback_url
    options = default_url_options_for_env
    webhooks_orange_money_sn_qrcode_confirmations_url(options)
  end

  def build_return_url
    options = default_url_options_for_env
    edit_project_contribution_url(contribution.project, contribution, options)
  end

  def default_url_options_for_env
    if ENV['HOST'] == "ns357509.ip-91-121-149.eu"
      host = [ENV['HOST'], ENV['PORT'].presence || 3000].join(':')
      { host: host }
    elsif Rails.env.development?
      { host: ENV['NGROK_HOST'].presence || 'http://localhost:3000' }
    else
      { protocol: :https }
    end
  end
end
