class Address < ActiveRecord::Base
  validates  :address, :city, :phone, :country, presence: true

  belongs_to :country
  belongs_to :customer
end
