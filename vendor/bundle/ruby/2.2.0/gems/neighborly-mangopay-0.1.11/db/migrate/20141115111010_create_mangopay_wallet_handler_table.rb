class CreateMangopayWalletHandlerTable < ActiveRecord::Migration
  def change
    create_table :mangopay_wallet_handlers do |t|
      t.references :project, index: true
      t.string :wallet_key, null: false

      t.timestamps
    end
  end
end
