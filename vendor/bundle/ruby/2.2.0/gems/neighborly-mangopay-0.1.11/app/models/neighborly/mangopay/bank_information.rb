module Neighborly::Mangopay
  class BankInformation < ActiveRecord::Base
    self.table_name = :bank_informations

    belongs_to :user, class_name: '::User'
    validates :bic, :iban, presence: true

    before_save :save_or_update_mangopay_bank_account

    private

    def save_or_update_mangopay_bank_account
      begin
        bank_account =  ::RecursiveOpenStruct.new(
                          ::MangoPay::BankAccount.create(Neighborly::Mangopay::Customer.new(user, {}).fetch.Id,
                            {
                              OwnerName: user.name,
                              Type: "IBAN",
                              OwnerAddress: user.address,
                              IBAN: iban,
                              BIC: bic
                            }
                          )
                        )
        self.key = bank_account.Id
        return key.present?
      rescue Exception => e
        raise "Wrong bank information: #{e.message}"
      end
    end
  end
end
