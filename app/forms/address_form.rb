class AddressForm
  include ActiveModel::Model
  include Virtus


=begin
  def initialize
    customer = Customer.find_by_id(customer_id)
    @address = customer.shipping_address.find_or_create_by()
  end
=end


  #shipping_address: [:first_name, :last_name, :address, :city, :country_id, :zipcode, :phone],
  attr_reader :address


  attribute :first_name, String
  attribute :last_name,  String
  attribute :address,    String
  attribute :city,       String
  attribute :country_id, Integer
  attribute :zipcode,    String
  attribute :phone,      String
  attribute :customer_id,Integer

  validates :first_name, presence: true
  validates :last_name,  presence: true
  validates :address,    presence: true
  validates :city,       presence: true
  validates :country_id, presence: true
  validates :zipcode,    presence: true
  validates :phone,      presence: true
  validates :customer_id,presence: true

  def shipping_address
    customer = Customer.find_by_id(customer_id)
    customer.shipping_address || Address.new
  end

=begin
  def save_shipping_address
    @object.shipping_address.assign_attributes(first_name: first_name, last_name: last_name,
                                              address:address,city: city,
                                              country_id: country_id, zipcode: zipcode,
                                              phone: phone)
  end
=end

  def persisted?
    false
  end

  def save
    if valid?
      persist!
      true
    else
      false
    end
  end

  def persist!

    shipping_address.assign_attributes(shipping_address: shipping_address)
    shipping_address.save!
  end


end