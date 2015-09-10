require 'rails_helper'

RSpec.describe CreditCard, type: :model do
  let(:credit_card) { FactoryGirl.create(:credit_card) }



  it 'has many orders' do
    expect(credit_card).to have_many(:orders)
  end

  it 'has a number' do
    expect(credit_card).to validate_presence_of(:number)
  end

  it 'has a number in format 0000-0000-0000-0000' do
    expect(FactoryGirl.build(:credit_card, number: '3120-0000-0000!0034')).not_to be_valid
  end

  it 'has a CVV' do
    expect(credit_card).to validate_presence_of(:CVV)
  end

  it 'has a CVV in format 000' do
    expect(FactoryGirl.build(:credit_card, CVV: '2!4')).not_to be_valid
  end

  it 'has an expiration_month' do
    expect(credit_card).to validate_presence_of(:expiration_month)
  end

  it 'has an expiration_year' do
    expect(credit_card).to validate_presence_of(:expiration_year)
  end

  it 'gets a display number' do
    expect(credit_card).to respond_to(:display_number)
  end

  it 'gets a display month' do
    expect(credit_card).to respond_to(:display_month)
  end

  it "gets a months' list" do
    expect(credit_card).to respond_to(:month_list)
  end

  it "gets a years' list" do
    expect(credit_card).to respond_to(:year_list)
  end
end
