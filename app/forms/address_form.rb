class AddressForm < Reform::Form
  property :first_name
  property :last_name
  property :address
  property :zip
  property :city
  property :phone
  property :country_id

  property :use_billing_address, empty: true

  def use_billing_address
    super || model.new_record?
  end



  def countries
    Country.all.pluck(:name, :id)
  end
end