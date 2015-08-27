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
  let(:book) { FactoryGirl.create(:book) }
  let(:order_item) { FactoryGirl.create(:order_item, order: order, book: book, quantity: 1) }

  describe 'GET #index' do
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

  end
  #???????
=begin
  describe 'POST #update_all' do
    it 'change quantity' do
    post :update_all, "quantity"=>{"#{order_item.id}"=>"3"}
    expect(order_item.quantity).to eq(3)
    end
  end
=end

  describe 'DELETE #destroy' do

  end

  describe 'DELETE #destroy_all' do
    it 'delete all order items from current order' do
      delete :destroy_all
      expect(order.order_items).to be_blank
    end

  end



end
