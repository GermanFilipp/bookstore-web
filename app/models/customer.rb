class Customer < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable
 include AddressSaver

  has_many  :orders
  has_many  :ratings
  has_many  :addresses
 # has_many  :credit_cards

  belongs_to :billing_address, class_name: "Address"
  belongs_to :shipping_address, class_name: "Address"


  validates :email,presence: true
  validates :email, uniqueness: { case_sensitive: false }


  def admin?
    self.admin
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |customer|
      customer.email = auth.info.email
      customer.password = Devise.friendly_token[0, 20]
      customer.first_name = auth.info.first_name
      customer.last_name = auth.info.last_name
      customer.provider = auth.provider
      customer.uid = auth.uid
    end
  end

  def order_in_progress
    self.orders.find_or_create_by(state: Order::STATE_IN_PROGRESS)
  end

  def last_orders
    self.orders.already_completed.order(state: :asc, completed_date: :desc).first
  end

  def all_orders
    self.orders.already_completed.order(state: :asc, completed_date: :desc)
  end

end
