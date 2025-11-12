class CreatePayPlusAfricaTransactions < ActiveRecord::Migration[6.1]
  def change
    create_table :pay_plus_africa_transactions do |t|
      t.references :contribution, foreign_key: true
      t.string :order_id_string
      t.string :reference
      t.string :status_string
      t.string :invoice_number
      t.text :payment_url
      t.text :notif_token

      t.timestamps
    end
  end
end
