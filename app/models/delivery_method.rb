class DeliveryMethod < ActiveRecord::Base
  STATE = %w(inactive, active)
  validates :name, :price, :state, presence: true
  validates :name, uniqueness: true


  enum state: STATE
  scope :active, -> {where state: 'active'}
end
