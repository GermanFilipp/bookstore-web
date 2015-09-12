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
      expect(response).to redirect_to(edit_customer_path)
    end

  end

  describe ' GET #edit' do
    before {get :edit}

    context 'cancan does not allow :edit' do
      before do
        ability.cannot :edit, Customer
        get :edit
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
      expect(response).to render_template("edit")
    end

  end

  describe 'PUT #email' do
    before { request.env['HTTP_REFERER'] = edit_customer_path }

    context 'cancan does not allow :email' do
      before do
        ability.cannot :email, Customer
        get :email, customer: FactoryGirl.attributes_for(:customer,email: 'hello@world.com')
      end
      it {expect(response).to redirect_to(new_customer_session_path) }
    end

    it_behaves_like 'success flash and redirect' do
      let(:req) { put :email, customer: FactoryGirl.attributes_for(:customer,email: 'hello@world.com') }
    end

    context 'customer enter new valid email' do
      it 'changes customer email' do
        put :email,customer: FactoryGirl.attributes_for(:customer,email: 'hello@world.com')
        customer.reload
        expect(customer.email).to eq 'hello@world.com'
      end

    end

    context 'customer enter not valid or blank email' do
      it 'not change customer email' do
        email = customer.email
        put :email,customer: FactoryGirl.attributes_for(:customer,email: nil)
        customer.reload
        expect(customer.email).to eq email
      end

      it 'show some error' do
        put :email,customer: FactoryGirl.attributes_for(:customer,email: nil)
        expect(customer.errors.full_messages).not_to be_nil
      end
    end
  end

  describe 'PUT #password' do

    context 'cancan does not allow :password' do
      before do
        ability.cannot :password, Customer
        get :password, customer: FactoryGirl.attributes_for(:customer,password: '1212424545')
      end
      it {expect(response).to redirect_to(new_customer_session_path) }
    end

    before { request.env['HTTP_REFERER'] = edit_customer_path }

    context 'customer enter valid current_password, password, password_confirmation' do
      it 'change customer password' do
        put :password,  customer: {current_password:'12345678', password: '45666678897849849', password_confirmation:'45666678897849849'}
        expect(response).to redirect_to(new_customer_session_path)
      end
    end

    context 'customer enter invalid password' do
      it 'change customer password' do
        put :password,  customer: {current_password:'1234567jiefid8', password: '45666678897849849', password_confirmation:'45666678897849849'}
        expect(response).to render_template('edit')
      end
    end

  end



  describe 'PUT #address'do
    before { request.env['HTTP_REFERER'] = edit_customer_path }

    context 'cancan does not allow :address' do
      before do
        ability.cannot :address, Customer
        get :address, billing_address: FactoryGirl.attributes_for(:address)
      end
      it {expect(response).to redirect_to(new_customer_session_path) }
    end

    context 'customer enter valid address params for ' do
      it '@billing_address' do
        customer.billing_address = FactoryGirl.create :address
        billing_address_params = FactoryGirl.attributes_for(:address)
        put :address, type: "billing", billing_address: billing_address_params
        address.reload
        expect(customer.billing_address) == billing_address_params
      end

      it '@shipping_address' do
        customer.shipping_address = FactoryGirl.create :address
        shipping_address_params = FactoryGirl.attributes_for(:address)
        put :address, type: "shipping", shipping_address: shipping_address_params
        address.reload
        expect(customer.shipping_address) == shipping_address_params
      end
    end

    context 'customer enter invalid address params for' do
      it '@billing_address' do
        put :address, type: "billing", billing_address: FactoryGirl.attributes_for(:address, zipcode: nil)
        expect(response).to render_template('edit')
      end

      it '@shipping_address' do
        put :address, type: "shipping", shipping_address: FactoryGirl.attributes_for(:address, zipcode: nil)
        expect(response).to render_template('edit')
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
      it 'deletes the customer' do
        expect{delete :destroy}.to change{Customer.count}.by(0)
      end

      it 'redirect to root path' do
        delete :destroy
        expect(response).to redirect_to(edit_customer_path)
      end
    end


  end
end
