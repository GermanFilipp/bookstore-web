require 'rails_helper'

RSpec.describe OrdersController, type: :controller do
  let(:customer) { FactoryGirl.create(:customer) }
  let(:ability) { Ability.new(customer) }
  before do
    allow(controller).to receive(:current_ability).and_return(ability)
    ability.can :manage, :all
    sign_in customer
  end
  describe 'GET #index' do
    context 'cancan does not allow :index' do
      before do
        ability.cannot :index, Order
        get :index
      end
      it { expect(response).to redirect_to(new_customer_session_path) }
    end

  end


  describe 'GET #show' do
    context 'cancan does not allow :show' do
      before do
        ability.cannot :show,Order
        get :show
      end
      it { expect(response).to redirect_to(new_customer_session_path) }
    end

  end
=begin

  def index
    @order = current_customer_order
    @order_items = @order.books
    @orders = current_customer.all_orders
  end

  # GET /orders/1
  def show
    @order = current_customer.orders.find(params[:id])
    @order_items = @order.books
    @order_total = @order.total_price+@order.delivery_price
  end
=end


end
