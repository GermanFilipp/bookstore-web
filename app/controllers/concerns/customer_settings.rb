module CustomerSettings
  extend ActiveSupport::Concern
=begin

  included do
    before_action  :set_data
  end

  def save_shipping_address
   return messages('shipping address') if @customer.save_address(customer_params[:shipping_address].merge(type: 'shipping'))
    show
  end

  def save_billing_address
    return messages('billing address') if @customer.save_address(customer_params[:billing_address].merge(type: 'billing'))
    show
  end

  def save_email
    return messages('e-mail') if @customer.update_attributes(customer_params[:email])
    show
  end

  def save_password
    if @customer.update_with_password(customer_params[:password])
      flash[:success] = 'Your password was updated.'
      redirect_to new_customer_session_path
    else
      show
    end
  end

  def set_data
    @customer = current_customer
    @customer_form = AddressForm.new(current_customer)
  end

  def messages(type)
    flash[:success] = "Your #{type} was updated."
    redirect_to :back
  end

  def customer_params
    params.permit(
        shipping_address: [:first_name, :last_name, :address, :city, :country_id, :zipcode, :phone],
        billing_address:  [:first_name, :last_name, :address, :city, :country_id, :zipcode, :phone],
        email: [:email],
        password: [:current_password, :password, :password_confirmation])
  end
=end



end
