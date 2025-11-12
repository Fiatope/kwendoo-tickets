class AddIsPrebookedToProjects < ActiveRecord::Migration
  def change
    change_table :projects do |t|
      t.boolean :is_prebooked, default: false
    end
  end
end
