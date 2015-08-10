class CustomersController < ApplicationController
  include UpdateCustomer
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

  def address
    type = params[:type] || 'billing'
    if @customer.save_address(addr_params(type).merge(type: type))
      redirect_to edit_customer_path, :notice => 'Your '+type+' address was updated.'
    else
      instance_variable_set("@#{type}_address", Address.new(addr_params(type)))

      edit
    end
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

  def customer_params
    params.require(:customer).permit(:email, :current_password, :password, :password_confirmation)
  end
end