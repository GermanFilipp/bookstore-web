class OrderStepsController < ApplicationController
  include Wicked::Wizard
  include UpdateCustomer
  helper_method :step_index_for, :current_step_index, :wizard_path, :next_wizard_path
  steps :address, :delivery, :payment, :confirm, :complete
  before_action :setter


  def show
    authorize! :show, @order
    jump_to @order_steps_form.check_last_step_errors if step.eql?(:confirm)
    render_wizard
  end

  def update
    authorize! :update, @order
    @order_steps_form.update(step, order_params)
    render_wizard @order_steps_form
  end

  private

  def setter
    @order =(step == :complete) ? current_customer.last_orders : current_customer_order
    @order_steps_form = OrderStepsForm.new(@order)
  end

  def order_params
    params.permit(
        shipping_address: [:first_name, :last_name, :address, :city, :country_id, :zipcode, :phone],
        billing_address:  [:first_name, :last_name, :address, :city, :country_id, :zipcode, :phone],
        shipping:         [:check],
        delivery:         [:delivery_method_id,:delivery_price],
        credit_card:      [:number, :expiration_month, :expiration_year, :CVV])
  end

end
