class CustomersForm
  include ActiveModel::Model

  def initialize(object)
    @object = object
  end

  def shipping_address
    @object.shipping_address ||= Address.new
  end

  def billing_address
    @object.billing_address ||= Address.new
  end

  def email
    @object.email
  end

  def update(params)
    if  params[:billing_address]
      billing_address.update_attributes(params[:billing_address])

    elsif params[:shipping_address]
      shipping_address.update_attributes(params[:shipping_address])

    elsif params[:email]
      @object.update_attributes(params[:email])

    elsif params[:password]
      @object.update_with_password(params[:password])
    else
      false
    end

  end

  def destroy
      @object.destroy
  end

end