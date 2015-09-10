module AddressSaver

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