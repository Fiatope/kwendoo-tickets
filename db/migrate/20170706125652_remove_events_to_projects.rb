class RemoveEventsToProjects < ActiveRecord::Migration
  def change
    remove_column :projects, :events_date, :date
  end
end
