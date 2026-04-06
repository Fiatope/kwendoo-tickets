module Neighborly::Mangopay::Match
  extend ActiveSupport::Concern
  included do

    # DISABLED — MangoPay deprecated, Stripe handles refunds
    def mangopay_refund
      Rails.logger.warn "[MangoPay] mangopay_refund called on Match but MangoPay is deprecated — skipping"
      true
    end

  end
end
