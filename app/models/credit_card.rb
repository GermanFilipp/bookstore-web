class CreditCard < ActiveRecord::Base
  belongs_to :customer
  has_many   :orders

  validates  :number, :CVV, :expiration_month, :expiration_year, :first_name, :last_name, presence: true
end
