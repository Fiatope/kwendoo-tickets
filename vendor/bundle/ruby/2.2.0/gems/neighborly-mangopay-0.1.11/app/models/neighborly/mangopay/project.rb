module Neighborly::Mangopay::Project
  extend ActiveSupport::Concern
  included do
    has_one :mangopay_wallet_handler, class_name: 'Neighborly::Mangopay::ProjectWalletHandler'
    has_many :orders, class_name: 'Neighborly::Mangopay::Order'

    def find_or_create_wallet
      return self.mangopay_wallet_handler if self.mangopay_wallet_handler.present?
      project_wallet = ::MangoPay::Wallet.create(
        Owners:      [::Neighborly::Mangopay::Customer.new(self.user, {}).fetch['Id']],
        Description: self.name,
        Currency:    self.currency.upcase
      )
      self.create_mangopay_wallet_handler!(wallet_key: project_wallet['Id'])
    end

    def process_payout
      begin
        ::Neighborly::Mangopay::Payout.new(self).complete!
        return 'Payout processed successfully'
      rescue Exception => e
        return e.message
      end
    end

    def available_currencies
      ::Configuration.fetch('currency').split(',')
    end

    def currency_sym
      begin
        if currency == 'USD'
          "$"
        else
          "€"
        end
      rescue
        "$"
      end
    end
  end

  def create_wallet_if_not_exists!
    return true if self.mangopay_wallet_handler.present?
    project_wallet = ::MangoPay::Wallet.create(
      Owners:      [::Neighborly::Mangopay::Customer.new(self.user, {}).fetch['Id']],
      Description: self.name,
      Currency:    self.currency.upcase
    )
    self.create_mangopay_wallet_handler!(wallet_key: project_wallet['Id'])
  end
end
