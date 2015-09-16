class CustomersController < ApplicationController
  authorize_resource
  include CustomerSettings


  def show
    @billing_address  ||= @customer.billing_address  || Address.new
    @shipping_address ||= @customer.shipping_address || Address.new
    render :show
  end

  def update
    if customer_params[:shipping_address]
      save_shipping_address
    elsif customer_params[:billing_address]
      save_billing_address
    elsif customer_params[:email]
      save_email
    elsif customer_params[:password]
      save_password
    else
      render :show
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
end