class CreateNeighborlyMangopayOrders < ActiveRecord::Migration
  def change
    create_table :neighborly_mangopay_orders do |t|
      t.references :project, index: true, null: false
      t.references :contribution, index: true, null: false
      t.references :user, index: true, null: false
      t.string :order_key, null: false
      t.string :refund_key

      t.timestamps
    end
  end
end
