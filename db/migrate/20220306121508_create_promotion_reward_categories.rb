class CreatePromotionRewardCategories < ActiveRecord::Migration[6.1]
  def change
    create_table :promotion_reward_categories do |t|
      t.references :promotion, foreign_key: true
      t.references :reward_category, foreign_key: true

      t.timestamps
    end
  end
end
