class CreatePromotions < ActiveRecord::Migration[6.1]
  def change
    create_table :promotions do |t|
      t.string :title
      t.string :code
      t.integer :discount
      t.integer :nbr_ticket
      t.references :project, foreign_key: true

      t.timestamps
    end
  end
end
