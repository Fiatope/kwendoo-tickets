class CreateRewardCategories < ActiveRecord::Migration[6.1]
  def change
    create_table :reward_categories do |t|
      t.string :name
      t.references :project, foreign_key: true
    end
  end
end
