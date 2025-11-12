class AddTransactionNumberToContributions < ActiveRecord::Migration
  def change
    change_table :contributions do |t|
      t.string :transaction_number
    end
  end
end
