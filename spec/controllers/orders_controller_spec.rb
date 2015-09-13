require 'rails_helper'

RSpec.describe OrdersController, type: :controller do
  let(:customer) { FactoryGirl.create(:customer) }
  let(:ability) { Ability.new(customer) }

  let(:order){FactoryGirl.create(:order,id: 1, customer: customer, total_price:1, delivery_price:2)}

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
    context 'return book' do
      before{get :index}

      it 'renders #index template' do
        expect(response).to render_template :index
      end

      it "assigns @order" do
        expect(assigns(:order)).not_to be_nil
      end

      it "assigns @order_items" do
        expect(assigns(:order_items)).not_to be_nil
      end

      it "assigns @orders" do
        expect(assigns(:orders)).not_to be_nil
      end

    end
  end


  describe 'GET #show' do
    context 'cancan does not allow :show' do
      before do
        ability.cannot :show,Order
        get :show, id: order.id
      end
      it { expect(response).to redirect_to(new_customer_session_path) }
    end

    before{get :show, id: order.id}
    it 'renders #show template' do
      expect(response).to render_template :show
    end

    it "assigns @order" do
      p order
      expect(assigns(:order)).not_to be_nil
    end

    it "assigns @order_items" do

      expect(assigns(:order_items)).not_to be_nil
    end

    it "assigns @orders" do
      expect(assigns(:order_total)).not_to be_nil
    end

  end

end
