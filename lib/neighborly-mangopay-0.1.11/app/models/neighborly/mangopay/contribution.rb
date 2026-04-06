module Neighborly::Mangopay::Contribution
  extend ActiveSupport::Concern
  included do

    has_one :order, class_name: 'Neighborly::Mangopay::Order'

    # DISABLED — MangoPay deprecated, Stripe handles refunds
    def mangopay_refund
      Rails.logger.warn "[MangoPay] mangopay_refund called but MangoPay is deprecated — skipping"
      true
    end

    # DISABLED — MangoPay deprecated
    # def create_order_in_transition
    #   self.create_order({
    #     user_id: user.id,
    #     project_id: project.id,
    #     order_key: payment_id
    #   })
    # end

    # DISABLED — MangoPay deprecated, no longer creating MangoPay orders on confirmation
    # state_machine :state, initial: :pending do
    #   after_transition all => :confirmed, :do => :create_order_in_transition
    # end
  end
end
