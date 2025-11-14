class Contribution < ActiveRecord::Base
  include Shared::StateMachineHelpers,
          Shared::PaymentStateMachineHandler,
          Contribution::CustomValidators,
          Shared::Notifiable,
          Shared::Payable,
          PgSearch::Model

  belongs_to :user
  belongs_to :project
  belongs_to :reward
  belongs_to :matching
  has_many   :matchings
  has_one :match, through: :matching
  has_many :wecashuptransactions
  has_many :ticket_categories_orders
  has_many :rewards, through: :ticket_categories_orders
  has_many :reward_categories, through: :project
  has_many :tickets, through: :ticket_categories_orders
  accepts_nested_attributes_for :ticket_categories_orders, allow_destroy: true
  has_many :orange_money_transactions
  has_many :pay_plus_africa_transactions

  #validates_presence_of :project, :user, :value
  validates_presence_of :project, :value
  validates :user, presence: true, on: :update
  
  validate :enough_tickets_remaining
  attr_accessor :custom_error

  before_create :compute_cfa_value

  scope :available_to_count,   -> { with_states(['confirmed', 'requested_refund', 'refunded']) }
  scope :available_to_display, -> { with_states(['confirmed', 'requested_refund', 'refunded']) }
  scope :anonymous,            -> { where(anonymous: true) }
  scope :credits,              -> { where(credits: true) }
  scope :not_anonymous,        -> { where(anonymous: false) }
  scope :confirmed_today,      -> { with_state('confirmed').where("contributions.confirmed_at::date = current_timestamp::date ") }
  scope :canceled_today,       -> { with_state('canceled').where("contributions.created_at::date = current_timestamp::date ") }
  scope :confirmed,            -> { with_state('confirmed') }
  scope :canceled,             -> { with_state('canceled') }
  scope :can_cancel,           -> { where("contributions.can_cancel") }
  # Contributions already refunded or with requested_refund should appear so that the user can see their status on the refunds list
  scope :can_refund,           ->{ where("contributions.can_refund") }

  pg_search_scope :pg_search, against: [
      [:key,            'A'],
      [:value,          'B'],
      [:payment_method, 'C'],
      [:payment_id,     'D']
    ],
    associated_against: {
      user:    %i(id name email),
      project: %i(name)
    },
    using: {
      tsearch: {
        dictionary: 'english'
      }
    },
    ignoring: :accents

  attr_accessor :tickets_count, :tickets_type

  before_validation do
    minimum_value = ticket_categories_orders.map do |ticket_categories_order|
      if Rails.cache.exist?('promotion_tickets') && Rails.cache.read('promotion_tickets').key?("#{ticket_categories_order.reward.id}")
        promotion_tickets = Rails.cache.read('promotion_tickets')
        promotion = Promotion.find(promotion_tickets["#{ticket_categories_order.reward.id}"]["promotion_id"][0])
        ticket_categories_order.count * (ticket_categories_order.reward.minimum_value - (ticket_categories_order.reward.minimum_value * promotion.discount / 100))
      else
        ticket_categories_order.count * ticket_categories_order.reward.minimum_value
      end
    end
    self.value = minimum_value.compact.sum
    # self.cfa_value = (value * conversion_rate).round
  end

  # def conversion_rate
  #   ENV['CFA_CONVERSION_RATE'].to_f || 656
  # end

  def generate_tickets
    ticket_categories_orders.each do |ticket_categories_order|
      ticket_categories_order.count.times do |i|
        # token = loop do
        #   random_token = SecureRandom.urlsafe_base64(nil, false)
        #   break random_token unless Ticket.exists?(token: random_token)
        # end
        if Rails.cache.exist?('user_tickets')
          user_tickets = Rails.cache.read('user_tickets')
          if ticket_categories_order.reward.couple?
            2.times do |j|
              name = user_tickets["name"][j]
              email = user_tickets["email"][j]
  
              @ticket = ticket_categories_order.tickets.create!(
                # token: token,
                validity_ends_at: (project.starts_at || project.start_date),
                seat: nil, # For later
                under_name: user.name, # For later
                name: name,
                email: email
              )
          end
          else
            puts "qeazeaze,  #{user_tickets}"
            name = user_tickets["name"][i]
            email = user_tickets["email"][i]

            @ticket = ticket_categories_order.tickets.create!(
              # token: token,
              validity_ends_at: (project.starts_at || project.start_date),
              seat: nil, # For later
              under_name: user.name, # For later
              name: name,
              email: email
            )
          end
        else
          @ticket = ticket_categories_order.tickets.create!(
            # token: token,
            validity_ends_at: (project.starts_at || project.start_date),
            seat: nil, # For later
            under_name: user.name # For later
          )
        end

        TicketWorker.perform_async(@ticket.id) if @ticket.present?
      end
    end
  end

  def matched_contributions
    self.class.where(matching_id: matchings)
  end


  def unique_identifier_for(provider_string)
    case provider_string
    when 'orange_money'
      "KWENDOOTKT-C#{id}-#{Time.now.to_i.to_s.last(8)}#{rand(1000)}"
    when 'pay_plus_africa'
      "KWENDOOTKT-C#{id}-#{Time.now.to_i.to_s.last(8)}#{rand(1000)}"
    end
  end


  def matches
    matched_contributions
  end

  def currency
    if self.payment_method == "Orange Money"
      "EUR"
    else
      self.project.currency
    end
  end

  def as_json(options = {})
    return super unless options.empty?

    PayableResourceSerializer.new(self).to_json
  end

  def recommended_projects
    user.recommended_projects.where("projects.id <> ?", project.id).order("count DESC")
  end

  def refund_deadline
    created_at + 180.days
  end

  def available_rewards
    Reward.where(project_id: self.project_id).where('minimum_value <= ?', self.value).order(:minimum_value)
  end

  def net_value
    if payment_service_fee_paid_by_user?
      value
    else
      value - payment_service_fee
    end
  end

  def payment_service_fee
    if match
      match.payment_service_fee / match.value * value
    else
      read_attribute(:payment_service_fee)
    end
  end

  def compute_cfa_value
    # Si le projet est déjà en FCFA/XAF/XOF, pas de conversion nécessaire
    if self.project && ['FCFA', 'XAF', 'XOF'].include?(self.project.currency)
      self.cfa_value = self.value.to_s.to_d
    else
      # Conversion EUR vers FCFA seulement si nécessaire
      conversion_rate = ENV['CFA_CONVERSION_RATE'] || 656
      self.cfa_value = self.value.to_s.to_d * conversion_rate.to_s.to_d
    end
  end

  private
  def enough_tickets_remaining
  end
end
