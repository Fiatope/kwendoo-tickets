class ChangeProjectIdToRewards < ActiveRecord::Migration[6.1]
  def change
    change_column_null :rewards, :project_id, true
  end
end
