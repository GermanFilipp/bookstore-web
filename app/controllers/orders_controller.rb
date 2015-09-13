class OrdersController < ApplicationController
  authorize_resource
  # GET /orders
  def index
    @orders = current_customer.all_orders
    @order = current_customer_order
    @order_items = @order.books

  end

  # GET /orders/1
  def show
    @order = current_customer.orders.find(params[:id])
    @order_items = @order.books
    @order_total = @order.total_price+@order.delivery_price
  end
end
