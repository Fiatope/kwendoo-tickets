class RemoveAssociationToUsers < ActiveRecord::Migration
  def change
    # This column does not exist...
    # remove_column :users, :association, :boolean
  end
end
