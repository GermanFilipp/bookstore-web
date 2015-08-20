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
    @delivery_methods = DeliveryMethod.active
    delivery_method_id = params[:delivery_method_id] || @order.delivery_method_id
    unless delivery_method_id
      @delivery_method =  @delivery_methods.first
    else
      @delivery_method = @delivery_methods.select{|delivery_method| delivery_method.id == delivery_method_id }.first
    end
  end

  def show_payment
    if @order.delivery_method_id.nil?
      @notice = 'Delivery method has not been set'
      return
    end
    @credit_card ||= @order.credit_card || CreditCard.new
  end

  def show_confirm
    @notice = 'Credit card details have not been saved!' if @order.credit_card_id.nil?
  end

  def show_complete

    @notice = 'Order processing has not been finished yet!' if @order.nil?
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
    @order.update(total_price: @order.total_price+delivery_params[:delivery_price].to_i)
    return @notice = 'Shipping method was successfully saved.' if @order.update(delivery_params)
  end

  def update_payment
    return @notice = 'Payment data was saved.'if @order.save_credit_card(credit_card_params)
  end

  def update_confirm
    @order.checkout!
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

  def delivery_params
    params.permit(:delivery_method_id, :delivery_price)
  end

  def credit_card_params
    params.require(:credit_card)
        .permit(:number, :expiration_month, :expiration_year, :CVV)
        .merge(customer_id: current_customer.id)
  end
end