class ChangeAccessTokenTypeToText < ActiveRecord::Migration
  def change
      change_column :authorizations, :access_token, :text   
  end
end
