class AddNonprofitauthToUsers < ActiveRecord::Migration
  def change
    add_column :users, :nonprofitauth, :boolean, DEFAULT: true
  end
end
