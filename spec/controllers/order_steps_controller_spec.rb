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

    context 'show_address' do
      before { get :show, id: :address }

      it 'render address template' do
        expect(response).to render_template('address')
      end

      it 'create @billing_address' do
        expect(assigns(:billing_address)).to be_instance_of Address
      end

      it 'create @shipping_address' do
        expect(assigns(:shipping_address)).to be_instance_of Address
      end

    end

    context 'show_delivery' do
      before { get :show, id: :delivery }

      it 'render delivery template' do
        expect(response).to render_template('delivery')
      end

      it 'add delivery to order' do
        expect(assigns(:delivery)).to be_instance_of DeliveryMethod
      end
    end

    context 'show payment' do
      before { get :show, id: :payment }

      it 'render order_payment template' do
        expect(response).to render_template('payment')
      end

      it 'create @credit_card' do
        expect(assigns(:credit_card)).to be_instance_of CreditCard
      end
    end

  end

end

