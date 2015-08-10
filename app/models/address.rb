class Address < ActiveRecord::Base
  validates  :address,:zipcode,:first_name,:last_name, :city, :phone, :country, presence: true

  belongs_to :country
  belongs_to :customer
end
