module Neighborly::Balanced
  class Refund
    FIXED_OPERATIONAL_FEE = 0.3

    attr_reader :paid_resource

    def initialize(paid_resource)
      @paid_resource = paid_resource
    end

    def complete!(reason, amount = paid_resource.value)
      unless amount.zero?
        refund_amount = ((amount + refundable_fees(amount)) * 100).round
        debit.refund(
          amount:      refund_amount,
          description: I18n.t('neighborly.balanced.refund.description',
            resource_id:   paid_resource.id,
            resource_name: paid_resource.class.model_name.human
          ),
          meta: {
            'reason' => I18n.t("neighborly.balanced.refund_reasons.#{reason}")
          }
        )
      end
      paid_resource.refund!
    end

    def debit
      @debit ||= ::Balanced::Debit.find("/debits/#{paid_resource.payment_id}")
    end

    def refundable_fees(refund_amount)
      percentual_fee = if paid_resource.payment_service_fee_paid_by_user
        refund_amount / paid_resource.value * paid_resource.payment_service_fee
      else
        0
      end

      (percentual_fee - FIXED_OPERATIONAL_FEE).round(2)
    end

    private

    def resource_amount
      to_be_refunded = if paid_resource.payment_service_fee_paid_by_user
        paid_resource.value + paid_resource.payment_service_fee
      else
        paid_resource.value
      end
      (to_be_refunded * 100 - FIXED_OPERATIONAL_FEE).round
    end
  end
end
