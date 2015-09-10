class Address < ActiveRecord::Base
  validates  :address,:first_name,:last_name, :city, :phone, :country,:zipcode,  presence: true
  #validates  :zipcode, format: { with: /[0-9]{5}/ }, presence: true
  belongs_to :country
  belongs_to :customer
end
