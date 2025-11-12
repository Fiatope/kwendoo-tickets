class MigsVirtualPaymentClientService

  attr_accessor :params

  def initialize(params)
    @params = params
  end

  def info_hash
    {
      card_type: card_type,
      transaction_reference: reference,
      transaction_number: transaction_number,
      receipt_number: receipt_number,
      verification_type: verification_type,
      verification_status: verification_status,
      card_last4: nil,
      response_message: response_message,
      response_code: response_code
    }
  end

  def amount
    params["vpc_Amount"]
  end

  def is_authorized?
    is_valid? && params["vpc_TxnResponseCode"] == "0"
  end

  def template_symbol
    case params['vpc_TxnResponseCode']
    when "0"
      :payment_confirmed
    when "2", "3", "5", "6", "8", "9"
      :contribution_failed_refused_by_bank
    when "4"
      :contribution_failed_card_not_active
    when "F"
      :contribution_failed_3DSecure_failed
    when "N"
      :contribution_failed_3DSecure_not_active
    else
      :contribution_failed_generic_error
    end
  end

  def verification_status
    params["vpc_VerStatus"] if is_valid?
  end

  def verification_type
    params["vpc_VerType"]
  end

  def card_type
    if params['vpc_Card'] == "MC"
      "MasterCard"
    elsif params['vpc_Card'] == "VC"
      "VISA"
    else 
      "Unknown"
    end
  end

  def response_code
    params['vpc_TxnResponseCode']
  end

  def reference
    params['vpc_MerchTxnRef']
  end

  def transaction_number
    params['vpc_TransactionNo']    
  end

  def receipt_number
    params['vpc_ReceiptNo']    
  end

  def response_message
    return I18n.t("services.migs_virtual_payment_client_service.response_compromised") unless is_valid?
    I18n.t("services.migs_virtual_payment_client_service.#{params['vpc_TxnResponseCode']}")
  end

  private
  def is_valid?
    response_string = params.select { |k, v| k[0..3] == "vpc_"}.reject { |k, v| k == "vpc_SecureHash" || k == "vpc_SecureHashType" }.sort.to_h.map{ |k, v| "#{k}=#{v}" }.join("&")
    expected_digest = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), [ENV["MASTERCARD_SECURE_HASH_SECRET"]].pack('H*'), response_string).upcase
    expected_digest == params["vpc_SecureHash"]
  end

end
