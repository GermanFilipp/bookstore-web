class OrderStepsController < ApplicationController
  include Wicked::Wizard
  helper_method :step_index_for
  steps :add_address, :check_delivery, :add_payment, :confirm, :complete

  def show
    case step
      when :add_address
        @billing_address ||= current_customer.billing_address || Address.new
        @shipping_address ||= current_customer.shipping_address || Address.new
      when :check_delivery

      when :add_payment

      when :confirm

      when :complete

    end
    render_wizard
  end

end
