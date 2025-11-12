class AddSanitaryPassToProjects < ActiveRecord::Migration[6.1]
  def change
    add_column :projects, :sanitary_pass, :boolean, :default => false
  end
end
