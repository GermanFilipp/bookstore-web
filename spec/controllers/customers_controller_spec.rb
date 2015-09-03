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

  describe ' GET #edit' do
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
    it 'changes customer email' do
      put :email,customer: FactoryGirl.attributes_for(:customer,email: 'hello@world.com')
      customer.reload

      expect(customer.email).to eq 'hello@world.com'
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


  describe 'PUT #address'do
    it 'changes customer address' do
    put :password, customer:FactoryGirl.attributes_for(:address, zipcode: '123456')

    address.reload

    expect(address.zipcode).to eq '123456'
    end
  end


  describe 'DELETE #destroy'do
    it 'deletes the customer' do

      expect{delete :destroy, id: customer}.to change{Customer.count}.by(0)
    end
  end
end
