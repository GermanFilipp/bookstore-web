class CustomersController < ApplicationController
  authorize_resource
  include CustomerSettings
  before_action  :set_data

  def show
    @billing_address  ||= @customer.billing_address  || Address.new
    @shipping_address ||= @customer.shipping_address || Address.new
    render :show
  end

  def update
    if @customer.update(customer_params)
      flash[:success] = "Your #{customer_params.keys.to_s.slice(2..-3)} was updated."
      redirect_to :back
    else
      show
    end
  end

  def destroy
    if params.has_key?(:remove_account_confirm)
      @customer.destroy
      redirect_to root_path
    else
      flash[:danger] = 'You should confirm your action!'
      redirect_to :action => "show"
    end
  end

  def set_data
    @customer = CustomersForm.new(current_customer)
  end

  def customer_params
    params.permit(
        shipping_address: [:first_name, :last_name, :address, :city, :country_id, :zipcode, :phone],
        billing_address:  [:first_name, :last_name, :address, :city, :country_id, :zipcode, :phone],
        email: [:email],
        password: [:current_password, :password, :password_confirmation])
  end
end