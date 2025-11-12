class Wecashuptransaction < ActiveRecord::Base
  belongs_to :contribution
  validates :transaction_uid, presence: true, uniqueness: true
  validates :transaction_token, presence: true, uniqueness: true
  validates :transaction_provider_name, presence: true
end
