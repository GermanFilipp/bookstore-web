require 'rails_helper'

RSpec.describe Order, type: :model do
  let(:order) { FactoryGirl.create :order }

  it 'is able to return books' do
    expect(order).to respond_to :books
  end

  it 'has a completed date' do
    expect(order).to respond_to(:completed_date)
  end

  it 'has a state' do
    expect(order).to validate_presence_of(:state)
  end

  it 'has a state as enum' do
    expect(order).to define_enum_for(:state)
  end

  it 'has a default state "in_progress"' do
    expect(order.state).to eq 'in_progress'
  end

  it 'gets a status' do
    expect(order).to respond_to(:state)
  end

  it 'has a customer' do
    expect(order).to respond_to(:customer)
  end

  it 'belongs to customer' do
    expect(order).to belong_to(:customer)
  end

  it 'has a credit card' do
    expect(order).to respond_to :credit_card
  end

  it 'belongs to credit card' do
    expect(order).to belong_to(:credit_card)
  end

  it 'has many order items' do
    expect(order).to have_many(:order_items)
  end

  it 'has a billing address' do
    expect(order).to respond_to :billing_address
  end

  it 'belongs to billing address' do
    expect(order).to belong_to(:billing_address)
  end

  it 'has a shipping address' do
    expect(order).to respond_to :shipping_address
  end

  it 'belongs to shipping address' do
    expect(order).to belong_to(:shipping_address)
  end

  it 'gets order total price' do
    book1 = FactoryGirl.create(:book, price: 1.99)
    book2 = FactoryGirl.create(:book, price: 2.99)
    order.add_book(book1, 1)
    order.add_book(book2, 2)
    expect(order.total_price).to eq 7.97
  end

  it 'gets order total items quantity' do
    book1 = FactoryGirl.create(:book)
    book2 = FactoryGirl.create(:book)
    order.add_book(book1, 5)
    order.add_book(book2, 2)
    expect(order.total_items).to eq 7
  end

  context '#save_credit_card' do
    before(:all) do
      @customer = FactoryGirl.create(:customer)
    end
    let(:credit_card) {FactoryGirl.create(:credit_card, customer: @customer)}
    let(:credit_card_params) {FactoryGirl.attributes_for(:credit_card, customer: @customer)}

    context 'when credit card was not set previously' do
      let(:order) {FactoryGirl.create(:order, customer: @customer)}

      it 'creates new credit card and set it to order' do
        expect(order.save_credit_card(credit_card_params)).to eq true
        expect(order.credit_card.id).to be > 0
      end

      it 'finds existing credit card and set it to order' do
        credit_card_params = {
            :number => credit_card.number,
            :expiration_year => credit_card.expiration_year,
            :expiration_month => credit_card.expiration_month,
            :CVV => credit_card.CVV,
            :customer => @customer
        }
        expect(order.save_credit_card(credit_card_params)).to eq true
        expect(Order.find(order.id).credit_card_id).to eq credit_card.id
      end
    end
    it 'returns false if credit card is invalid' do
      order = FactoryGirl.create(:order, customer: @customer)
      rand_123_number = [1, 2, 3].sample
      credit_card_params[:number] = '' if (rand_123_number&1 > 0)
      credit_card_params[:code]   = '' if (rand_123_number&2 > 0)
      expect(order.save_credit_card(credit_card_params)).to eq false
    end

    it 'updates data of the credit card previously saved for the order' do
      order = FactoryGirl.create(:order, customer: @customer, credit_card: credit_card)
      expect(order.save_credit_card(credit_card_params)).to eq true
      expect(Order.find(order.id).credit_card_id).to eq credit_card.id
    end
  end

#need to do

  context '#set_completed_at' do
    it 'sets current date & time in completed_at field' do
      Timecop.freeze
      order.send(:set_completed_at)
      expect(order.completed_at).to eq(Time.zone.now)
    end

    it 'sets current date & time wich saves only after checkout' do
      expect(order.completed_at).to be nil
      order.send(:set_completed_at)
      order.reload
      expect(order.completed_at).to be nil
      order.checkout!
      expect(order.completed_at).not_to be nil
    end
  end

end
