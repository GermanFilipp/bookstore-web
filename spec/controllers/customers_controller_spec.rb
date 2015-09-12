require 'rails_helper'


RSpec.describe CustomersController, type: :controller do

  let(:customer) {FactoryGirl.create :customer}
  let(:ability) { Ability.new(customer) }
  let(:address) {FactoryGirl.create :address,customer: customer}

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

    context 'cancan does not allow :edit' do
      before do
        ability.cannot :edit, Customer
        get :edit
      end
      it {expect(response).to redirect_to(new_customer_session_path) }
    end

    before {get :edit}
    it 'show @billing_address' do
      expect(assigns(:billing_address)).to be_instance_of Address
    end

    it 'show @shipping_address' do
      expect(assigns(:shipping_address)).to be_instance_of Address
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

    it 'changes customer email' do
      put :email,customer: FactoryGirl.attributes_for(:customer,email: 'hello@world.com')
      customer.reload
      expect(customer.email).to eq 'hello@world.com'
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

    it_behaves_like 'success flash and redirect' do
      let(:req) { put :password, customer: FactoryGirl.attributes_for(:customer,password: '1212424545')}
    end


  end

=begin
  describe 'PUT #password' do
    it 'changes customer password' do
      pass = customer.password
      customer = {current_password:'12345678', password: '45666678897849849', password_confirmation:'45666678897849849'}
      put :password, customer
      customer.reload
      expect(customer.password).not_to eq pass
    end
  end
=end

=begin
"type"=>"billing",
 "billing_address"=>{"first_name"=>"jkjsdkj",
 "last_name"=>"fkajsakfj",
 "address"=>"jkvdjavk",
 "city"=>"kdvndkv",
 "country_id"=>"1",
 "zipcode"=>"cdjvkd",
 "phone"=>"kjcsnv"},
 "commit"=>"SAVE"}
=end

  describe 'PUT #address'do
    it 'changes customer address' do
      put :address, type: "billing", billing_address: {first_name: "jkjsdkj", last_name: "fkajsakfj", address: "jkvdjavk", city: "kdvndkv", country_id: "1", zipcode: "cdjvkd", phone: "kjcsnv"}

      address.reload
      expect(response).to render_template("edit")
    end
  end



  describe 'DELETE #destroy'do
    it 'deletes the customer' do

      expect{delete :destroy, id: customer}.to change{Customer.count}.by(0)
    end
  end
end
