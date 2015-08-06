class OrderItemsController < ApplicationController

  before_action :current_order

  load_and_authorize_resource
  def show
    @order_items = @order.order_items
  end

  def destroy
    @order.order_items.destroy_all
    redirect_to order_item_path
  end

  def remove_item
    @order.order_items.find(params[:item_id]).destroy
    redirect_to order_item_path
  end

  def create
    book = Book.find_by_id(order_params[:book_id])
    quantity = order_params[:quantity]
    @order.add_book(book,quantity.to_i)
    redirect_to :back ,  notice: 'Book was successfully added to cart.'
  end

  def update
    params[:quantity].each do |item_id, quantity|
      @order.order_items.find_by_id(item_id).update(:quantity => quantity)
    end
    redirect_to order_item_path
  end


  def current_order
    @order = current_customer.order_in_progress
  end


  def order_params
    params.require(:orders).permit(:book_id, :quantity )
  end
end
