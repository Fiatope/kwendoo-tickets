class AddMigsDetailsToContributions < ActiveRecord::Migration
  def change
    change_table :contributions do |t|
      t.string :card_type
      t.string :transaction_reference
      t.string :receipt_number
      t.string :verification_type
      t.string :verification_status
      t.string :card_last4
      t.string :response_message
      t.string :response_code
    end
  end
end
