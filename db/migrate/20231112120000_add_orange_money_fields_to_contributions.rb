class AddOrangeMoneyFieldsToContributions < ActiveRecord::Migration
  def up
    add_column :contributions, :response_code, :string unless column_exists?(:contributions, :response_code)
    add_column :contributions, :transaction_number, :string unless column_exists?(:contributions, :transaction_number)
    add_column :contributions, :response_message, :string unless column_exists?(:contributions, :response_message)
  end

  def down
    remove_column :contributions, :response_code if column_exists?(:contributions, :response_code)
    remove_column :contributions, :transaction_number if column_exists?(:contributions, :transaction_number)
    remove_column :contributions, :response_message if column_exists?(:contributions, :response_message)
  end
end