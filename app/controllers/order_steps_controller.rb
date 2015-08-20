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
  end

  def update
    send("update_#{step}")
    redirect_to next_wizard_path, :notice => @notice
    send("show_#{step}")
  end

  private
  def setter
    @order =(step == :complete) ? current_customer.last_orders : current_customer_order
  end
end
