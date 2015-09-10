require 'rails_helper'

RSpec.describe OrderStepsController, type: :controller do
  let(:customer) { FactoryGirl.create(:customer) }
  let(:ability) { Ability.new(customer) }
  let(:delivery) {FactoryGirl.create(:delivery_method)}

  before do
    allow(controller).to receive(:current_ability).and_return(ability)
    ability.can :manage, :all
    sign_in customer
  end

  let!(:order) { customer.order_in_progress }


  describe 'GET #show' do

    context 'cancan does not allow :show' do
      before do
        ability.cannot :show, Order
        get :show, id: :address
      end
      it { expect(response).to redirect_to(new_customer_session_path) }
    end


    context 'show_address' do
      before { get :show, id: :address }

      it 'render address template' do
        expect(response).to render_template('address')
      end
    end

    context 'show_delivery' do
      before { get :show, id: :delivery }

      it 'render delivery template' do
        expect(response).to render_template('delivery')
      end

    end

    context 'show payment' do
      before { get :show, id: :payment }

      it 'render order_payment template' do
        expect(response).to render_template('payment')
      end

    end

    context 'show confirm' do
      before { get :show, id: :confirm }

      it 'render confirm template' do
        expect(response).to render_template('confirm')
      end

    end

    context 'show complete' do
      it 'render complete template' do
        order.update(billing_address: FactoryGirl.create(:address), shipping_address: FactoryGirl.create(:address),
                     delivery_method: FactoryGirl.create(:delivery_method), credit_card: FactoryGirl.create(:credit_card))
        get :show, id: :complete
        expect(response).to render_template('complete')
      end

    end

  end

  describe 'PATCH #update' do

    context 'cancan does not allow :show' do
      before do
        ability.cannot :update, Order
        get :update, id: :address
      end
      it { expect(response).to redirect_to(new_customer_session_path) }
    end

    before do
      @params = { id: :address, billing_address: FactoryGirl.attributes_for(:address),
                  shipping_address: FactoryGirl.attributes_for(:address) }
      put :update, id: :address
    end

    it 'build order' do
      expect(assigns(:order_steps_form)).not_to be_nil
    end

    it 'update order with step and params' do
      expect(assigns(:order_steps_form)).to receive(:update)
      patch :update, @params
    end

    it 'next step if order save' do
      expect(response).to redirect_to(action: :show, id: :order_delivery)
    end

    it 'render current step if order not save' do
      @params[:billing_address][:address] = nil
      patch :update, @params
      expect(response).to render_template('address')
    end

  end

end

