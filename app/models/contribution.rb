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
  has_many :orange_money_sn_qr_code_transactions
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

  # Called from PaymentStateMachineHandler after a contribution transitions
  # to :confirmed. It MUST NOT raise: any exception here rolls back the
  # state transition, the contribution stays :pending, the webhook returns
  # 500, the user lands back on /edit asking to pay again (we have seen
  # this exact regression in production).
  #
  # Reads `user_tickets` from Rails.cache if it is there — but the cache
  # may be absent (different Puma/Sidekiq worker than the one that served
  # the /create action, :memory_store cache, TTL expiry, Rails.cache.clear
  # by another request, …). Every cache access is nil-safe; every
  # Ticket#create! is wrapped in rescue so a single-ticket failure never
  # wipes the whole confirmation.
  def generate_tickets
    user_tickets = read_user_tickets_from_cache

    ticket_categories_orders.each do |tco|
      count = tco.count.to_i
      next if count <= 0

      couple = begin
        tco.reward && tco.reward.couple?
      rescue => e
        Rails.logger.warn "[generate_tickets contrib=#{id} tco=#{tco.id}] couple? failed: #{e.class} #{e.message}"
        false
      end

      count.times do |i|
        if couple
          # Couple reward: issue 2 physical tickets per ordered unit, each
          # with its own name/email pulled from cache positions 0 and 1.
          2.times { |j| create_one_ticket_safely(tco, user_tickets, j) }
        else
          create_one_ticket_safely(tco, user_tickets, i)
        end
      end
    end
  end

  private

  def read_user_tickets_from_cache
    return nil unless Rails.cache.exist?('user_tickets')
    Rails.cache.read('user_tickets')
  rescue => e
    Rails.logger.warn "[generate_tickets contrib=#{id}] cache read failed: #{e.class} #{e.message}"
    nil
  end

  def cached_ticket_field(user_tickets, key, index)
    return nil unless user_tickets.is_a?(Hash)
    val = user_tickets[key]
    return nil unless val.is_a?(Array)
    val[index]
  end

  def create_one_ticket_safely(tco, user_tickets, index)
    name  = cached_ticket_field(user_tickets, "name",  index).presence
    email = cached_ticket_field(user_tickets, "email", index).presence

    ticket = tco.tickets.create!(
      validity_ends_at: (project.starts_at || project.start_date),
      seat: nil,
      under_name: user.try(:name),
      name: name,
      email: email
    )
    TicketWorker.perform_async(ticket.id) if ticket && defined?(TicketWorker)
    ticket
  rescue => e
    Rails.logger.error "[generate_tickets contrib=#{id} tco=#{tco.id} i=#{index}] ticket create failed: #{e.class} #{e.message}"
    # Swallow: do not take down the payment confirmation because one
    # ticket row could not be inserted. An operator can regenerate the
    # missing ticket(s) via rails console if this ever fires.
    nil
  end

  public

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
    stored_currency = self[:currency].presence
    return stored_currency if stored_currency.present?

    project_currency = self.project.try(:currency).presence
    return project_currency if project_currency.present?

    self.payment_method == "Orange Money" ? "FCFA" : "EUR"
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
    Reward.not_soon.where(project_id: self.project_id).where('minimum_value <= ?', self.value).order(:minimum_value)
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
