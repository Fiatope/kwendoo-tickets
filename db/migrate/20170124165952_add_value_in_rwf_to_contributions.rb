class AddValueInRwfToContributions < ActiveRecord::Migration
  def change
    add_column :contributions, :value_in_rwf, :decimal
  end
end
