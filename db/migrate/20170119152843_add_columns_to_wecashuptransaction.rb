class AddColumnsToWecashuptransaction < ActiveRecord::Migration
  def change
    add_column :wecashuptransactions, :transaction_uid, :string
    add_column :wecashuptransactions, :transaction_token, :string
    add_column :wecashuptransactions, :transaction_provider_name, :string
    add_column :wecashuptransactions, :transaction_confirmation_code, :string
    add_reference :wecashuptransactions, :contribution, index: true
  end
end
