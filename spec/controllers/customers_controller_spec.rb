require 'rails_helper'


RSpec.describe CustomersController, type: :controller do

  let!(:customer) {FactoryGirl.create :customer}
  let(:ability) { Ability.new(customer) }
  let(:address) {FactoryGirl.create :address}

  before do
    allow(controller).to receive(:current_ability).and_return(ability)
    ability.can :manage, :all
    sign_in customer
  end

  shared_examples 'success flash and redirect' do
    before { req }

    it 'success flash' do
      expect(flash[:success]).to be_present
    end

    it 'redirect to HTTP_REFERER' do
      expect(response).to redirect_to(customer_path)
    end

  end

  describe ' GET #show' do
    before {get :show}

    context 'cancan does not allow :edit' do
      before do
        ability.cannot :show, Customer
        get :show
      end
      it {expect(response).to redirect_to(new_customer_session_path) }
    end

    context 'Customer already have' do

       it '@billing address' do
         customer.billing_address = FactoryGirl.create :address
         customer.reload
         expect(assigns(:billing_address)) == customer.billing_address
       end

      it '@shipping address' do
        customer.shipping_address = FactoryGirl.create :address
        customer.reload
        expect(assigns(:shipping_address)) == customer.shipping_address
      end
    end

    context 'Customer have not address' do

      it 'show @billing_address' do
        expect(assigns(:billing_address)).to be_instance_of Address
      end

      it 'show @shipping_address' do
        expect(assigns(:shipping_address)).to be_instance_of Address
      end

    end

    it 'render the :edit view' do
      expect(response).to render_template("show")
    end

  end

  describe 'PUT #update' do
    before { request.env['HTTP_REFERER'] = customer_path }
    context 'cancan does not allow :update' do
      before do
        ability.cannot :update, Customer
        get :update, customer: FactoryGirl.attributes_for(:customer,email: 'hello@world.com')
      end
      it {expect(response).to redirect_to(new_customer_session_path) }
    end

    it_behaves_like 'success flash and redirect' do
      let(:req) { put :update, email: FactoryGirl.attributes_for(:customer,email: 'hello@world.com') }
    end

    context 'customer enter valid address params for ' do
      it '@billing_address' do
        customer.billing_address = FactoryGirl.create :address
        billing_address_params = FactoryGirl.attributes_for(:address)
        put :update, billing_address: billing_address_params
        address.reload
        expect(customer.billing_address) == billing_address_params
      end

      it '@shipping_address' do
        customer.shipping_address = FactoryGirl.create :address
        shipping_address_params = FactoryGirl.attributes_for(:address)
        put :update, shipping_address: shipping_address_params
        address.reload
        expect(customer.shipping_address) == shipping_address_params
      end
    end

    context 'customer enter invalid address params for' do
      it '@billing_address' do
        put :update, type: "billing", billing_address: FactoryGirl.attributes_for(:address, zipcode: nil)
        expect(response).to render_template('show')
      end

      it '@shipping_address' do
        put :update, type: "shipping", shipping_address: FactoryGirl.attributes_for(:address, zipcode: nil)
        expect(response).to render_template('show')
      end
    end


    context 'customer enter new valid email' do
      it 'changes customer email' do
        put :update,email: FactoryGirl.attributes_for(:customer,email: 'hello@world.com')
        customer.reload
        expect(customer.email).to eq 'hello@world.com'
      end

    end

    context 'customer enter invalid or blank email' do
      it 'not change customer email' do
        email = customer.email
        put :update,email: FactoryGirl.attributes_for(:customer,email: nil)
        customer.reload
        expect(customer.email).to eq email
      end

      it 'show some error' do
        put :update,email: FactoryGirl.attributes_for(:customer,email: nil)
        expect(customer.errors.full_messages).not_to be_nil
      end
    end

    context 'customer enter valid current_password, password, password_confirmation' do
      it 'change customer password' do
        put :update,  password: {current_password:'12345678', password: '45666678897849849', password_confirmation:'45666678897849849'}
        expect(response).to have_http_status(302)
      end
    end

    context 'customer enter invalid password' do
      it 'change customer password' do
        put :update,  password: {current_password:'1234567jiefid8', password: '45666678897849849', password_confirmation:'45666678897849849'}
        expect(response).to render_template('show')
      end
    end
  end


  describe 'DELETE #destroy'do

    context 'cancan does not allow :address' do
      before do
        ability.cannot :destroy, Customer
        delete :destroy, remove_account_confirm:'1'
      end
      it {expect(response).to redirect_to(new_customer_session_path) }
    end
     context 'customer delete account with confirm' do
       it 'deletes the customer' do
         expect{delete :destroy, remove_account_confirm:'1'}.to change{Customer.count}.by(-1)
       end

       it 'redirect to root path' do
         delete :destroy, remove_account_confirm:'1'
         expect(response).to redirect_to(root_path)
       end
     end

    context 'customer delete account without confirm' do
      it 'not deletes the customer' do
        expect{delete :destroy}.to change{Customer.count}.by(0)
      end

      it 'not redirect to root path' do
        delete :destroy
        expect(response).to redirect_to(customer_path)
      end
    end

  end

end
