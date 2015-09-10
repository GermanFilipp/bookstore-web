require 'rails_helper'

shared_examples 'a customer who saves address' do
  let(:address_params) { FactoryGirl.attributes_for(:address, customer: customer).merge(:type => address_type) }

  describe '#save_address' do
    it 'updates data of address previously saved for the order' do
      address = FactoryGirl.create(:address, customer: customer)
      customer.update("#{address_type}_address_id".to_sym => address.id)
      expect(customer.save_address(address_params)).to eq true
      expect(Customer.find(customer.id).send("#{address_type}_address_id")).to eq address.id
    end

    context 'when address is invalid' do
      it 'returns false ' do
        rand_123_number = [1, 2, 3].sample
        address_params[:address]  = '' if (rand_123_number&1 > 0)
        address_params[:zipcode] = '' if (rand_123_number&2 > 0)
        expect(customer.save_address(address_params)).to eq false
      end
    end

    context 'when address was not set previously' do
      it 'creates new address and set it to customer' do
        expect(customer.save_address(address_params)).to eq true
        expect(customer.send("#{address_type}_address").id).to be > 0
      end

      it 'finds existing address and set it to customer' do
        address = FactoryGirl.create(:address, address_params.except(:type))
        expect(customer.save_address(address_params)).to eq true
        expect(Customer.find(customer.id).send("#{address_type}_address_id")).to eq address.id
      end
    end

    context 'when billing and shipping address ids are the same' do
      it 'creates new address and set it to customer' do
        address = FactoryGirl.create(:address, customer: customer)
        customer.update(billing_address_id: address.id, shipping_address_id: address.id)
        expect(customer.save_address(address_params)).to eq true
        expect(Customer.find(customer.id).send("#{address_type}_address_id")).to eq address.id+1
      end

      it 'finds existing address and set it to customer' do
        address = FactoryGirl.create(:address, address_params.except(:type))
        customer.update(billing_address_id: address.id, shipping_address_id: address.id)
        expect(customer.save_address(address_params)).to eq true
        expect(Customer.find(customer.id).send("#{address_type}_address_id")).to eq address.id
      end
    end

    context 'when address was used in placed orders' do
      it 'creates new address and set it to customer' do
        address = FactoryGirl.create(:address, customer: customer)
        customer.update("#{address_type}_address_id".to_sym => address.id)
        FactoryGirl.create(:already_completed, customer: customer, "#{address_type}_address".to_sym => address)
        expect(customer.save_address(address_params)).to eq true
        expect(Customer.find(customer.id).send("#{address_type}_address_id")).to eq address.id
      end

      it 'finds existing address and set it to customer' do
        address = FactoryGirl.create(:address, address_params.except(:type))
        FactoryGirl.create(:already_completed, customer: customer, "#{address_type}_address".to_sym => address)
        expect(customer.save_address(address_params)).to eq true
        expect(Customer.find(customer.id).send("#{address_type}_address_id")).to eq address.id
      end
    end
  end
end


RSpec.describe Customer, type: :model do
  let(:customer) { FactoryGirl.create :customer }

  it 'has an email' do
    expect(customer).to validate_presence_of(:email)
  end

  it 'has a unique email' do
    expect(customer).to validate_uniqueness_of(:email)
  end

  it 'has a current password' do
    expect(customer).to respond_to(:current_password)
  end

  it 'has a password' do
    expect(customer).to respond_to(:password)
  end

  it 'has a password confirmation' do
    expect(customer).to respond_to(:password_confirmation)
  end

  it 'has many reviews' do
    expect(customer).to have_many(:ratings)
  end

  it 'has many orders' do
    expect(customer).to have_many(:orders)
  end


  it 'has many addresses' do
    expect(customer).to have_many(:addresses)
  end

  it 'gets a billing address' do
    expect(customer).to respond_to(:billing_address)
  end

  it 'belongs to billing address' do
    expect(customer).to belong_to(:billing_address)
  end

  it 'gets a shipping address' do
    expect(customer).to respond_to(:shipping_address)
  end

  it 'belongs to shipping address' do
    expect(customer).to belong_to(:shipping_address)
  end
  context 'when saving billing address' do
    it_behaves_like 'a customer who saves address' do
      let(:address_type) { 'billing' }
    end
  end

  context 'when saving shipping address' do
    it_behaves_like 'a customer who saves address' do
      let(:address_type) { 'shipping' }
    end
  end
  describe '#order_in_progress' do

    context 'when order in progress has not exist' do
      it 'create and return order in progress' do
        order_in_progress = customer.order_in_progress
        expect(order_in_progress).to be_a Order
        expect(order_in_progress.state).to eq "in_progress"
      end
    end

    context 'when order in progress was create before' do
      it 'return current order in progress' do
        order = FactoryGirl.create(:order, customer: customer)
        order_in_progress = customer.order_in_progress
        expect(order.id).to eq order_in_progress.id
      end
    end
  end

  describe  '#all_orders' do
    it 'return order with state different from "in progress" ' do
      order1 = FactoryGirl.create(:already_completed, customer: customer)
      order2 = FactoryGirl.create(:already_completed, customer: customer)
      expect(customer.all_orders).to include(order1)
      expect(customer.all_orders).to include(order2)
      expect(customer.all_orders.length).to eq 2
    end
  end

=begin
  describe '#last_order' do
    it 'return last order' do
               FactoryGirl.create(:already_completed, customer: customer)
      order1 = FactoryGirl.create(:already_completed, customer: customer)
      expect(customer.last_orders.id).to eq order1.id
    end
  end
=end
end



