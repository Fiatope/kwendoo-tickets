class CreatePromotionRewards < ActiveRecord::Migration[6.1]
  def change
    create_table :promotion_rewards do |t|
      t.references :promotion, foreign_key: true
      t.references :reward, foreign_key: true
    end
  end
end
