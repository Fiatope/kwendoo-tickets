class AddPromoteToRewards < ActiveRecord::Migration[6.1]
  def change
    add_column :rewards, :promote, :boolean, default: false
  end
end
