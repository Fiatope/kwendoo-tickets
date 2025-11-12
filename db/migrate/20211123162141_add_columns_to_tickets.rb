class AddColumnsToTickets < ActiveRecord::Migration[6.1]
  def change
    change_column_null :tickets, :ticket_categories_order_id, true
    add_reference :tickets, :reward, foreign_key: true, null: true
    add_column :tickets, :name, :string
    add_column :tickets, :email, :string
  end
end
