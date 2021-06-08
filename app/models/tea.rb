class Tea < ApplicationRecord
  has_many :subscription_teas
  has_many :subscriptions, through: :subscription_teas

  validates :title, :description, :brew_time_seconds, :temperature, :presence => true
end
