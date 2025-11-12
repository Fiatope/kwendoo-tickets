class Ticket < ActiveRecord::Base
  belongs_to :ticket_categories_order
  belongs_to :reward
  # validates :ticket_categories_order, presence: true
  before_save :generate_token, if: :new_record?
  before_save :generate_qr_code

  mount_uploader :qr_code, QrCodeUploader, mount_on: :qr_code

  scope :list_of_tickets, ->(p) { joins("LEFT OUTER JOIN ticket_categories_orders ON ticket_categories_orders.id = tickets.ticket_categories_order_id
  LEFT OUTER JOIN rewards ON rewards.id = ticket_categories_orders.reward_id OR rewards.id = tickets.reward_id
  LEFT OUTER JOIN reward_categories ON reward_categories.id = rewards.reward_category_id").where("reward_categories.project_id = ?", p.id).distinct.select("tickets.*, rewards.title") }

  def contribution
    ticket_categories_order.contribution
  end

  def generate_token
    self.token = rand(36**8).to_s(36).upcase
  end

  def generate_qr_code
    image = RQRCode::QRCode.new(self.token).as_png
    s = StringIO.new(image.to_blob)
    def s.original_filename; "qr_code.png"; end
    self.qr_code = s
  end

  def category
    ticket_categories_order.reward.title
  end

  def as_csv(options={})
    { 
      qr_code: token,
      category: category
    }
  end
end
