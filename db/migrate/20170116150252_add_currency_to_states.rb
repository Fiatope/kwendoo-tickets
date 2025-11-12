class AddCurrencyToStates < ActiveRecord::Migration
  def change
    add_column :states, :currency, :string
  end
end
