class CreateRegisteredCardsTable < ActiveRecord::Migration
  def change
    create_table :mangopay_registered_cards do |t|
      t.references :user, index: true, null: false
      t.string :currency, null: false, default: 'EUR'
      t.string :key, null: false
    end
  end
end
