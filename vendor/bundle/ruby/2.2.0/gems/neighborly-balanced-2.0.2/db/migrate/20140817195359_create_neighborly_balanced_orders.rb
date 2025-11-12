class CreateNeighborlyBalancedOrders < ActiveRecord::Migration
  def change
    create_table :neighborly_balanced_orders do |t|
      t.references :project, index: true, null: false
      t.string :href, null: false

      t.timestamps
    end
  end
end
