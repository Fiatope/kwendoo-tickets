class AddValueInEurosToContribution < ActiveRecord::Migration
  def change
    add_column :contributions, :value_in_euros, :decimal
  end
end
