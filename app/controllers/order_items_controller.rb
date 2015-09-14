class OrderItemsController < ApplicationController
  authorize_resource :except => :destroy
  load_and_authorize_resource :only => :destroy
  before_action :current_order

  def index
    @order_items = @order.order_items
  end

  def destroy_all
    @order.order_items.destroy_all
    flash[:success] = 'Order was successfully destroyed'
    redirect_to order_items_path
  end

  def destroy

    @order_item.destroy
    flash[:success] = 'One item from order was successfully deleted'
    redirect_to order_items_path


  end

  def create
    book = Book.find_by_id(order_params[:book_id])
    quantity = order_params[:quantity]
    @order.add_book(book,quantity.to_i)
    flash[:success] = 'Book was successfully added to cart.'
    redirect_to(:back)
  end

  def update
    params[:quantity].each do |item_id, quantity|
      @order.order_items.find_by_id(item_id).update(:quantity => quantity)
    end
    add_coupon unless params[:coupon].blank?
    flash[:success] = 'Order was successfully updated'
    redirect_to order_items_path
  end

  private

  def add_coupon
    @coupon = Coupon.find_by(number: params[:coupon])
    if @coupon
      if @order.coupon
        flash[:error] = 'You already use coupon code'
      else
        @order.update(coupon: @coupon)
        flash[:success] = 'Coupon code has been accepted'
      end
    else
      flash[:error] = 'Coupon not found'
    end
  end

  def current_order
    @order = current_customer.order_in_progress
  end


  def order_params
    params.require(:orders).permit(:book_id, :quantity )
  end
end
