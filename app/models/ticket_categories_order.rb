class TicketCategoriesOrder < ActiveRecord::Base
  has_many :tickets
  belongs_to :contribution
  belongs_to :reward
  belongs_to :promotion
  validates :count, presence: true
  validate :enough_tickets_remaining

  before_save :check_promotion

  def check_promotion
    if Rails.cache.exist?('promotion_tickets') && Rails.cache.read('promotion_tickets').key?("#{reward.id}")
      promotion_tickets = Rails.cache.read('promotion_tickets')
      self.promotion = Promotion.find(promotion_tickets["#{reward.id}"]["promotion_id"][0])
    end
  end

  private

  def enough_tickets_remaining
    return true if reward.maximum_contributions.nil?
    if self.count > reward.remaining
      self.errors.add(:count, "there are not enough tickets remaining for #{reward.title}")
      return false
    end
  end
end
