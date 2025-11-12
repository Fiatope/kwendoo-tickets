module Neighborly::Mangopay::Creditcard
  class Payment
    attr_reader :engine_name, :customer, :resource, :attrs

    def initialize(engine_name, customer, resource, return_url, attrs = {})
      @engine_name  = engine_name
      @customer     = customer
      @resource     = resource
      @return_url   = return_url
      @attrs        = attrs
    end

    def debit!
      perform_debit!
    end

    def checkout!
      resource.update_attributes(
        payment_id:                       @debit.try(:Id),
        payment_method:                   engine_name,
        payment_service_fee:              0,
        payment_service_fee_paid_by_user: false
      )
      begin
        resource.confirm!
      rescue
        resource.cancel!
      ensure
        resource.cancel! if @debit.try(:Id).blank?
      end
    end

    def successful?
      %w(000000).include? @debit.try(:ResultCode)
    end

    private

    def perform_debit!
      debit_params = {
        AuthorId:       @customer.Id,
        DebitedFunds:   {
          Currency:      @resource.project.currency.upcase,
          Amount:        (@resource.value * 100).to_f
        },
        Fees:           {
          Currency:       @resource.project.currency.upcase,
          Amount:         0.0
        },
        CreditedWalletId:     @resource.project.find_or_create_wallet.wallet_key,
        CreditedUserId:       project_owner_customer.Id,
        ReturnURL:            @return_url,
        Culture:              'FR',
        CardType:             'CB_VISA_MASTERCARD',
        SecureModeReturnURL:  @return_url,
        SecureMode:           "DEFAULT",
        CardId:               @attrs[:card_key]
      }

      order  = Neighborly::Mangopay::OrderProxy.new(resource.project)

      @debit = order.direct_card_payin(debit_params)
    end

    def card
      Mangopay::Card.fetch(@attrs.fetch(:card_key))
    end

    def resource_name
      resource.class.model_name.singular
    end

    def debit_description
      I18n.t('description',
             project_name: resource.try(:project).try(:name),
             scope: "neighborly.mangopay.creditcard.payments.debit.#{resource_name}")
    end

    def project_owner_customer
      @project_owner_customer ||= Neighborly::Mangopay::Customer.new(
        resource.project.user, {}).fetch
    end

    def meta
      PayableResourceSerializer.new(resource).to_json
    end
  end
end
