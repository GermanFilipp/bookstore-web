class CreditCardForm
  include ActiveModel::Model


  attr_reader :order

  def initialize(order)
    @order = order
  end



  def check_previous_state
    false if @order.delivery_method_id.nil?
  end


  def init_credit_card
    @order.credit_card ||= CreditCard.new
  end

  def update(params)
    @order.save_credit_card(params[:credit_card])
  end

end