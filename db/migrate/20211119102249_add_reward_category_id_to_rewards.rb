class AddRewardCategoryIdToRewards < ActiveRecord::Migration[6.1]
  def change
    add_reference :rewards, :reward_category, foreign_key: true
  end
end
