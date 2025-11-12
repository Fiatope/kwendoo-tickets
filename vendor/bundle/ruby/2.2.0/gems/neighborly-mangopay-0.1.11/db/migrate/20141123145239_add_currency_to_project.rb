class AddCurrencyToProject < ActiveRecord::Migration
  def change
    add_column :projects, :currency, :string, default: "EUR", null: false
  end
end
