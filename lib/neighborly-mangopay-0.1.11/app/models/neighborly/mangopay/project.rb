module Neighborly::Mangopay::Project
  extend ActiveSupport::Concern
  included do
    has_one :mangopay_wallet_handler, class_name: 'Neighborly::Mangopay::ProjectWalletHandler'
    has_many :orders, class_name: 'Neighborly::Mangopay::Order'

    # DISABLED — MangoPay deprecated
    def find_or_create_wallet
      Rails.logger.warn "[MangoPay] find_or_create_wallet called but MangoPay is deprecated — skipping"
      self.mangopay_wallet_handler
    end

    # DISABLED — MangoPay deprecated
    def process_payout
      Rails.logger.warn "[MangoPay] process_payout called but MangoPay is deprecated — skipping"
      'MangoPay is deprecated — use Stripe for payouts'
    end

    def available_currencies
      ENV['CURRENCY'].split(',')
    end

    def currency_sym
      begin
        if currency == 'USD'
          "$"
        elsif currency == 'CAD'
          "C$"
        elsif currency == 'GBP'
          "£"
        elsif currency == 'CHF'
          "Fr" 
        elsif ['XAF', 'FCFA', 'CFA', 'XOF'].include?(currency)
          'FCFA'
        else
          "€"
        end
      rescue
        "$"
      end
    end
  end

  # DISABLED — MangoPay deprecated
  def create_wallet_if_not_exists!
    Rails.logger.warn "[MangoPay] create_wallet_if_not_exists! called but MangoPay is deprecated — skipping"
    true
  end
end
