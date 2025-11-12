class AddEventdateToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :event_date, :date
  end
end
