require 'rails_helper'

RSpec.describe OrderStepsController, type: :controller do
  let(:customer) { FactoryGirl.create(:customer) }
  let(:ability) { Ability.new(customer) }
  let!(:order){customer.order_in_progress}
  let!(:order_steps_form){OrderStepsForm.new(order)}

  before do
    allow(controller).to receive(:current_ability).and_return(ability)
    ability.can :manage, :all
    sign_in customer
  end

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


      it 'redirect to address if address does not exist' do
        get :show, id: :confirm
        expect(response).to redirect_to(action: :show, id: :address)
      end

      it 'redirect_to delivery if delivery does not exist' do

        order.update(billing_address: FactoryGirl.create(:address), shipping_address: FactoryGirl.create(:address))
        get :show, id: :confirm
        p order
        expect(response).to redirect_to(action: :show, id: :delivery)

      end

      it 'redirect_to credit_card if credit_card does not exist' do

        order.update(billing_address: FactoryGirl.create(:address), shipping_address: FactoryGirl.create(:address),
                    delivery_method: FactoryGirl.create(:delivery_method))
        get :show, id: :confirm
        p order
        expect(response).to redirect_to(action: :show, id: :payment)
      end

      it 'render confirm template' do

        order.update(billing_address: FactoryGirl.create(:address),
                     shipping_address: FactoryGirl.create(:address),
                    delivery_method: FactoryGirl.create(:delivery_method),
                     credit_card: FactoryGirl.create(:credit_card))
        get :show, id: :confirm
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

    context 'cancan does not allow :update' do
      before do
        ability.cannot :update, Order
        patch :update, id: :address, billing_address: FactoryGirl.attributes_for(:address),
              shipping_address: FactoryGirl.attributes_for(:address),shipping: {check:'0'}
      end
      it { expect(response).to redirect_to(new_customer_session_path) }
    end



    before do
      @params = { id: :address, billing_address: FactoryGirl.attributes_for(:address),
                  shipping_address: FactoryGirl.attributes_for(:address) , shipping:{check:0} }

      allow(order_steps_form).to receive(:update).and_return(true)
      allow(order_steps_form).to receive(:save).and_return(true)
    end

    it 'build order' do
      patch :update, @params
      expect(assigns(:order_steps_form)).not_to be_nil
    end

    it 'save valid order step' do
      patch :update, {id: :address, billing_address: FactoryGirl.attributes_for(:address), shipping_address: FactoryGirl.attributes_for(:address) , shipping:{check:0}}
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it 'render current step if order not save' do
      @params[:billing_address][:address] = nil
      patch :update, @params
      expect(response).to render_template('address')
    end


  end

end

