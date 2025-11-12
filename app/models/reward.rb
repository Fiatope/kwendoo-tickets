# coding: utf-8
class Reward < ActiveRecord::Base
  include RankedModel

  belongs_to :reward_category
  has_many :ticket_categories_orders
  has_many :contributions, through: :ticket_categories_orders
  has_many :tickets
  has_many :promotion_rewards, dependent: :destroy
  has_many :promotions, through: :promotion_rewards

  ranks :row_order, with_same: :project_id

  validates_presence_of :title, :minimum_value, :description
  # validates_numericality_of :minimum_value, greater_than_or_equal_to: 10.00
  validates_numericality_of :maximum_contributions, only_integer: true, greater_than: 0, allow_nil: true
  scope :remaining, -> { where("maximum_contributions IS NULL OR (maximum_contributions IS NOT NULL AND (SELECT COUNT(*) FROM contributions WHERE state IN ('confirmed', 'waiting_confirmation') AND reward_id = rewards.id) < maximum_contributions)") }
  scope :sort_asc, -> { order('id ASC') }
  scope :not_soon, -> { where('soon is not true') }
  scope :soon, -> { where(soon: true) }

  scope :list_of_tickets, -> { left_outer_joins(ticket_categories_orders: [:tickets]).distinct.select("rewards.*, count(tickets.*) as count").group("rewards.id") }

  delegate :display_deliver_prevision, :display_remaining, :name, :display_minimum,
           :medium_description, :last_description, :display_description, to: :decorator

  def to_param
    return "#{id}" unless title
    "#{id}-#{title.parameterize}"
  end

  def decorator
    @decorator ||= RewardDecorator.new(self)
  end

  def sold_out?
    maximum_contributions && total_compromised >= maximum_contributions
  end

  def total_compromised
    reward_category.project.contributions.with_states(['confirmed', 'waiting_confirmation']).map { |e| e.ticket_categories_orders.where(reward_id: id).map(&:count) }.flatten.sum
  end

  def remaining
    return nil unless maximum_contributions
    maximum_contributions - total_compromised 
  end
end
