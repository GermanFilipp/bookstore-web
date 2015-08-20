require 'rails_helper'

RSpec.describe DeliveryMethod, type: :model do

  let(:delivery_method) {FactoryGirl.create :delivery_method}

  it 'has a name' do
    expect(delivery_method).to validate_presence_of(:name)
  end

  it 'has a unique name' do
    expect(delivery_method).to validate_uniqueness_of(:name)
  end

  it 'has a state' do
    expect(delivery_method).to validate_presence_of(:state)
  end

  it 'has a price' do
    expect(delivery_method).to validate_presence_of(:price)
  end

  it 'has a default state "active"' do
    expect(delivery_method.state).to eq 'active'
  end
end
