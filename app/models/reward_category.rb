class RewardCategory < ActiveRecord::Base
  belongs_to :project
  has_many :rewards, dependent: :destroy

  accepts_nested_attributes_for :rewards

  validates_presence_of :name
end
