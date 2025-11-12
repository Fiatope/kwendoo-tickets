class PromotionReward < ActiveRecord::Base
    belongs_to :promotion
    belongs_to :reward
end
