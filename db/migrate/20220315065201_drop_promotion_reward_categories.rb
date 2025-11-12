class DropPromotionRewardCategories < ActiveRecord::Migration[6.1]
  def change
    drop_table :promotion_reward_categories, if_exists: true
  end
end
