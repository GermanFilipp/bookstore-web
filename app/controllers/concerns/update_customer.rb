module UpdateCustomer
  extend ActiveSupport::Concern

  def addr_params(type)
    address_params = params.require((type+'_address').to_sym).
        permit(:first_name, :last_name, :address, :city, :country_id, :zipcode, :phone)
    address_params = address_params.merge(customer_id: current_customer.id) unless @customer.nil?
    address_params
  end

  def set_errors_for(object, property)
    @errors[property.to_sym] = Array.new unless @errors[property.to_sym]
    errors = instance_variable_get("@#{object}").errors.full_messages.uniq
    if errors.length == 0
      entity = instance_variable_get("@#{property}") || instance_variable_get("@#{object}").send(property)
      errors = entity.errors.full_messages.uniq if entity && entity.invalid?
    end
    @errors[property.to_sym] |= errors
  end




end