class AddressForm
  include ActiveModel::Model


  attr_reader :order

  def initialize(order)
    @order = order
  end

  def billing_address
    @order.billing_address ||= @order.customer.billing_address || Address.new
  end

  def shipping_address
    @order.shipping_address ||= @order.customer.shipping_address || Address.new
  end

  def update(params)
    params[:shipping_address] = params[:billing_address] if use_billing_address?(params)
    @order.save_address(params[:billing_address].merge(type: 'billing'))
    @order.save_address(params[:shipping_address].merge(type: 'shipping'))

  end

  def use_billing_address?(params)
    params[:shipping][:check].eql? '1'
  end

  def save
    @order.save
  end

end