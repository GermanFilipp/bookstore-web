class CustomersController < ApplicationController
  authorize_resource
  include UpdateCustomer
  before_action  :set_data

  def edit
    @billing_address  ||= @customer.billing_address  || Address.new
    @shipping_address ||= @customer.shipping_address || Address.new
    render :edit
  end

  def email
    if @customer.update(customer_params)
      flash[:success] = 'Your e-mail was updated.'
      redirect_to edit_customer_path
    else
      edit
    end
  end

  def password
    if @customer.update_with_password(customer_params)
      flash[:success] = 'Your password was updated.'
      redirect_to edit_customer_path
    else
      edit
    end
  end

  def address
    type = params[:type] || 'billing'
    if @customer.save_address(addr_params(type).merge(type: type))
      flash[:success] = 'Your '+type+' address was updated.'
      redirect_to edit_customer_path
    else
      edit
    end
  end

  def destroy
    if params.has_key?(:remove_account_confirm)
      @customer.destroy
      flash[:success] = 'POTRACHENO'
      redirect_to root_path
    else
      flash[:success] = 'You should confirm your action!'
      redirect_to edit_customer_path
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