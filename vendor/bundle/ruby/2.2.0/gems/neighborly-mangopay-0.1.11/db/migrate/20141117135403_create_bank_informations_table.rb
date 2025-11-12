class CreateBankInformationsTable < ActiveRecord::Migration
  def change
    create_table :bank_informations do |t|
      t.references :user, index: true, null: false
      t.string :iban
      t.string :bic
      t.string :key
    end
  end
end
