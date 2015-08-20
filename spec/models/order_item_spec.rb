require 'rails_helper'

RSpec.describe OrderItem, type: :model do
  let(:order_item) { FactoryGirl.create(:order_item) }

  it 'belongs to book' do
    expect(order_item).to belong_to(:book)
  end

  it 'has an order' do
    expect(order_item).to validate_presence_of(:order)
  end

  it 'belongs to order' do
    expect(order_item).to belong_to(:order)
  end

  it 'has a price' do
    expect(order_item).to validate_presence_of(:price)
  end

  it 'has a quantity' do
    expect(order_item).to validate_presence_of(:quantity)
  end


  describe '#find_by_order_id' do

    it 'must return current order item' do

      order = FactoryGirl.create(:order, id:2)
      order_item1 =   FactoryGirl.create(:order_item,order: order)

      expect(OrderItem.find_by_order_id(order)).to eq order_item1
    end
  end
end
