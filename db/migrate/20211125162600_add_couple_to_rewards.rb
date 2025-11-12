class AddCoupleToRewards < ActiveRecord::Migration[6.1]
  def change
    add_column :rewards, :couple, :boolean, :default => false
  end
end
