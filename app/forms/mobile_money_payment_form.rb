class MobileMoneyPaymentForm
  include Virtus.model
  include ActiveModel::Model

  attribute :payingaccountidatsp, String
  attribute :paymentspid_name, String 

  def save
    false
  end

  private

  def persist!
  end
end
