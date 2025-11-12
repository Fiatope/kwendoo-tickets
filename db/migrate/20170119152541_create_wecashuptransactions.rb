class CreateWecashuptransactions < ActiveRecord::Migration
  def change
    create_table :wecashuptransactions do |t|

      t.timestamps
    end
  end
end
