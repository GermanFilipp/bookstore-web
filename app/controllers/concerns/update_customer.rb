module UpdateCustomer
  extend ActiveSupport::Concern

  def addr_params(type)
    address_params = params.require((type+'_address').to_sym).
        permit(:first_name, :last_name, :address, :city, :country_id, :zipcode, :phone)
    address_params = address_params.merge(customer_id: current_customer.id) unless @customer.nil?
    address_params
  end




end