class AddCurrencyToContributions < ActiveRecord::Migration
  def change
    add_column :contributions, :currency, :string
  end
end
