class AddColumnToWecashuptransaction < ActiveRecord::Migration
  def change
    add_column :wecashuptransactions, :conversion_rate, :string
    add_column :wecashuptransactions, :currency, :string
    add_column :wecashuptransactions, :value, :string
  end
end
