class Customer < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable


  has_many  :orders
  has_many  :ratings
  has_many  :addresses
  has_many  :credit_cards

  belongs_to :billing_address, class_name: "Address"
  belongs_to :shipping_address, class_name: "Address"

  accepts_nested_attributes_for :addresses
      validates :email,presence: true
  validates :email, uniqueness: { case_sensitive: false }


  def admin?
    self.admin
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid:auth.uid).first_or_create do |customer|
      customer.provider = auth.provider
      customer.uid = auth.uid
      customer.first_name = auth.info.first_name
      customer.last_name  = auth.info.last_name
      customer.email = auth.info.email
      customer.password = Devise.friendly_token.first[0,20]
    end
  end

  def order_in_progress
    self.orders.find_or_create_by(state: Order::STATE_IN_PROGRESS)
  end

  def order_in_queue
    self.orders.where(state: 'in queue')
  end

  def order_in_delivery
    self.orders.where(state: 'in delivery')
  end

  def order_delivered
    self.orders.where(state: 'delivered')
  end

  def save_address(address_params= {})
     address_type = (address_params[:type]+'_address').to_sym
     address_params.delete(:type)
     address = self.send(address_type)
     if (address.nil? || self.billing_address_id == self.shipping_address_id)
       address = Address.find_or_create_by(address_params)
       address.valid? && self.update(address_type => address)
     else
       address.update(address_params)
     end
  end
end
