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

  it 'blongs to coupon' do
    expect(order).to belong_to(:coupon)
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




end
