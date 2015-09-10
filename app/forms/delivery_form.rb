class DeliveryForm
  include ActiveModel::Model

  attr_reader :order

  def initialize(order)
    @order = order
  end


  def delivery_methods
    DeliveryMethod.active
  end

  def select_delivery_method(params)
    delivery_method_id = params[:delivery_method_id] || @order.delivery_method_id
    unless delivery_method_id
      @delivery_method =  delivery_methods.first
    else
      @delivery_method = delivery_methods.select{|delivery_method| delivery_method.id == delivery_method_id }.first
    end
  end

  def check_previous_state
    if @order.billing_address.nil? || @order.shipping_address.nil?
      false
    end
  end

  def update(params)
    @order.update(total_price: @order.total_price+delivery_params_to_i(params))
    return true if @order.update(delivery_method_id: params[:delivery][:delivery_method_id],delivery_price: params[:delivery][:delivery_price])
  end


  def delivery_params_to_i(params)
    params[:delivery][:delivery_price].to_i
  end
end
