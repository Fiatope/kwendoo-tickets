class AddCguToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :cgu, :boolean, :default => false
  end
end
