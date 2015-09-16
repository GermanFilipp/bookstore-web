class OrderStepsForm
  include ActiveModel::Model


  def initialize(order)
    @order = order
  end

  def billing_address
    @order.billing_address ||= @order.customer.billing_address || Address.new
  end

  def shipping_address
    @order.shipping_address ||= @order.customer.shipping_address || Address.new
  end

  def delivery_methods
    DeliveryMethod.active
  end

  def credit_card
    @order.credit_card ||= CreditCard.new
  end

  def use_billing_address?(params)
    params[:shipping][:check].eql? '1'
  end

  def delivery_params_to_i(params)
    params[:delivery][:delivery_price].to_i
  end

  def save
    @order.save
  end


  def check_last_step_errors
    return :address unless @order.billing_address && @order.shipping_address
    return :delivery unless @order.delivery_method
    return :payment unless @order.credit_card

  end
  def create_credit_card(credit_card)
    if @order.credit_card
      @order.credit_card.assign_attributes(credit_card)
    else
      @order.create_credit_card(credit_card)
    end
  end

  def update(step, params)
    case step
      when :address
        params[:shipping_address] = params[:billing_address] if use_billing_address?(params)
        billing_address.assign_attributes(params[:billing_address])
        shipping_address.assign_attributes(params[:shipping_address])
      when :delivery
        @order.update(total_price: @order.total_price+delivery_params_to_i(params))
        return true if @order
                           .update(delivery_method_id: params[:delivery][:delivery_method_id],delivery_price: params[:delivery][:delivery_price])
      when :payment
        create_credit_card(params[:credit_card])
      when :confirm
        @order.checkout!
    end
  end
end