class AddOfficialDocumentsToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :official_document, :string
    add_column :users, :official_document2, :string
    add_column :users, :official_document3, :string
    add_column :users, :official_document4, :string
  end
end
