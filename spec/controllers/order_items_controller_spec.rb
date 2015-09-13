require 'rails_helper'

RSpec.describe OrderItemsController, type: :controller do
  let(:customer) { FactoryGirl.create(:customer) }
  let(:ability) { Ability.new(customer) }

  before do
    allow(controller).to receive(:current_ability).and_return(ability)
    ability.can :manage, :all
    sign_in customer
  end

  let!(:order) { FactoryGirl.create(:order, customer: customer) }
  let!(:book) { FactoryGirl.create(:book, id: 1) }
  let(:order_item) { FactoryGirl.create(:order_item, order: order, book: book, quantity: 1) }


  describe 'GET #index' do

    context 'cancan does not allow :index' do
      before do
        ability.cannot :index, OrderItem
        get :index
      end
      it { expect(response).to redirect_to(new_customer_session_path) }
    end

    before do
      get :index
      customer.reload
    end

    it '#current_order' do
      expect(controller).to receive(:current_order)
      get :index
    end

    it 'create order' do
      expect(order).not_to be_nil
    end

    it 'have order item' do
      expect(order.order_items).not_to be_nil
    end
  end

  describe 'POST #create' do

    context 'cancan does not allow :create' do
      before do
        ability.cannot :create, OrderItem
        post :create, orders:{quantity: 2, book_id: 2}
      end
      it { expect(response).to redirect_to(new_customer_session_path) }
    end

    before { request.env['HTTP_REFERER'] = root_path }
    it 'add book to order_items' do
      book2 = FactoryGirl.create(:book, id: 2)
      book3 = FactoryGirl.create(:book, id: 3)
      post :create, orders: {quantity: 2 , book_id: 2}
      post :create, orders:{quantity: 2, book_id: 3}
      order.reload
      expect(OrderItem.count).to eq 2
    end

  end


  describe 'POST #update_all' do

    context 'cancan does not allow :update' do
      before do
        ability.cannot :update, OrderItem
        post :update, "orders"=>{"quantity"=>"2", "book_id"=>"2"}
      end
      it { expect(response).to redirect_to(new_customer_session_path) }
    end


    it 'change quantity' do
      post :update, "quantity"=>{"#{order_item.id}"=>"3"}
      order_item.reload
      expect(order_item.quantity).to eq(3)
    end
  end


  describe 'DELETE #destroy' do

    context 'cancan does not allow :destroy' do
      before do
        ability.cannot :destroy, OrderItem
        delete :destroy, {id: order_item.id}
      end
      it { expect(response).to redirect_to(new_customer_session_path) }
    end

    it 'delete one current order item from order' do
      delete :destroy, {id: order_item.id}
      order.reload
      expect(order.order_items).not_to include order_item
    end
  end

  describe 'DELETE #destroy_all' do

    context 'cancan does not allow :destroy_all' do
      before do
        ability.cannot :destroy_all, OrderItem
        delete :destroy_all
      end
      it { expect(response).to redirect_to(new_customer_session_path) }
    end

    it 'delete all order items from current order' do
      delete :destroy_all
      order.reload
      expect(order.order_items).to be_blank
    end

  end



end
