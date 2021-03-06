class OrdersController < ApplicationController
  load_and_authorize_resource
  # GET /orders
  def index
    @orders = @orders.all_completed_orders
    @order = current_customer_order
    @order_items = @order.books

  end

  # GET /orders/1
  def show
    @order_items = @order.books
    @order_total = @order.total_price+@order.delivery_price
  end
end
