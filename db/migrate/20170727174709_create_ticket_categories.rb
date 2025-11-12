class CreateTicketCategories < ActiveRecord::Migration
  def change
    create_table :ticket_categories_orders do |t|
      t.integer :contribution_id
      t.integer :reward_id
      t.integer :count
    end
    create_table :tickets do |t|
      t.integer :ticket_categories_order_id
      t.string :token
      t.datetime :validity_ends_at
      t.string :seat
      t.string :under_name
    end
    change_table :projects do |t|
      t.date     :start_date
      t.date     :end_date
      t.datetime :starts_at
      t.datetime :ends_at
    end
  end
end
