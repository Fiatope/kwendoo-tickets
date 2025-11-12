class AddCountryToProjects < ActiveRecord::Migration[6.1]
  def change
    add_column :projects, :country, :string
  end
end
