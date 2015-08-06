class CustomersController < ApplicationController

  before_action  :set_data

  def edit
    @billing_address  ||= @customer.billing_address  || Address.new
    @shipping_address ||= @customer.shipping_address || Address.new
    render :edit
  end

  def email
    if @customer.update(user_params)
      redirect_to edit_customer_path, :notice => 'Your e-mail was updated.'
    else
      edit
    end
  end

  def password
    if @customer.update_with_password(user_params)
      redirect_to edit_customer_path, :notice => 'Your password was updated.'
    else
      edit
    end
  end

  def billing_address
   #in progress
  end

  def shipping_address
    #in progress
  end

  def destroy
    if params.has_key?(:remove_account_confirm)
      @customer.destroy
      redirect_to root_path
    else
      redirect_to edit_customer_path, :notice => 'You should confirm your action!'
    end
  end


  private
  def set_data
    @customer = current_customer

  end

  def billing_address_params
    params.require(:billing_address).
        permit(:first_name, :last_name, :address, :city, :country_id, :zipcode, :phone).merge(customer_id: @customer.id)
  end
 # duplicate params
  def shipping_address_params
    params.require(:shipping_address).
        permit(:first_name, :last_name, :address, :city, :country_id, :zipcode, :phone).merge(customer_id: @customer.id)
  end
  def user_params
    params.require(:user).permit(:email, :current_password, :password, :password_confirmation)
  end
end