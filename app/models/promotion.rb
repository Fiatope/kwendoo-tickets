class Promotion < ActiveRecord::Base
    belongs_to :project
    has_many :promotion_rewards, dependent: :destroy
    has_many :rewards, through: :promotion_rewards
    has_many :ticket_categories_orders, dependent: :destroy

    validates_presence_of :title, :discount
    validates_numericality_of :discount, only_integer: true, greater_than: 0
    validates_numericality_of :nbr_ticket, only_integer: true, greater_than: 0, allow_nil: true

    before_save :generate_code, if: :new_record?

    delegate :user, to: :decorator

    def generate_code
        self.code = rand(36**8).to_s(36).slice(0,5).upcase
    end

    def decorator
        @decorator ||= PromotionDecorator.new(self)
    end
end
