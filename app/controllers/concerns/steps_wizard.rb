module StepsWizard
  extend ActiveSupport::Concern



  def show_address
    @billing_address ||= @order.billing_address|| current_customer.billing_address || Address.new
    @shipping_address ||= @order.shipping_address|| current_customer.shipping_address || Address.new
  end

  def show_delivery
    if @order.billing_address.nil? || @order.shipping_address.nil?
      @notice = 'Your order address have not been set correctly'
       return
    end
    @delivery = DeliveryMethod.active
    delivery_method_id = params[:delivery_method_id] || @order.delivery_method_id
  end

  def show_payment

  end
  def show_confirm

  end

  def show_complete

  end

  def update_address
    if save_address('billing') && save_address('shipping')
      @notice = 'Your addresses have been saved.'
    else
      @billing_address  = Address.new(addr_params('billing'))
      @shipping_address = Address.new(addr_params('shipping'))
    end
  end

  def update_delivery

  end

  def update_payment

  end

  def update_confirm

  end

  def update_complete

  end

  private
  def save_address(type)
    if type == 'shipping' && params.has_key?(:use_billing_address)
      return @order.update_attribute(:shipping_address_id, @order.billing_address_id)
    elsif type == 'billing'
      return @order.update_attribute(:billing_address_id, current_customer.billing_address_id)
    elsif type == 'shipping'
      return @order.update_attribute(:shipping_address_id, current_customer.shipping_address_id)
    end
    unless current_customer.save_address(addr_params(type).merge(type: type))
      return false
    end
  end
end