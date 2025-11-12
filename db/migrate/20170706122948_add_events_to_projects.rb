class AddEventsToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :events_date, :date
  end
end
