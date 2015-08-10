class OrderStepsController < ApplicationController
  include Wicked::Wizard
  include StepsWizard
  include UpdateCustomer
  helper_method :step_index_for, :current_step_index, :wizard_path, :next_wizard_path
  steps :address, :delivery, :payment, :confirm, :complete
  before_action :setter
  def show


    send("show_#{step}")
    redirect_to previous_wizard_path, :notice => @notice and return unless @notice.nil?
    render_wizard
=begin
    case step
      when :address
        @billing_address ||= current_customer.billing_address || Address.new
        @shipping_address ||= current_customer.shipping_address || Address.new
        @order = current_customer_order
      when :delivery
        @delivery = DeliveryMethod.all
      when :payment
        @credit_card ||= current_customer.credit_card || CreditCard.new
      when :confirm

      when :complete

    end
    render_wizard
=end
  end

  def update
    send("update_#{step}")
    redirect_to next_wizard_path, :notice => @notice and return if @errors.length == 0

  end

  private
  def setter
    @order = current_customer_order
  end
end
