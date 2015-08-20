require 'rails_helper'

RSpec.describe Country, type: :model do
  let(:country) {FactoryGirl.create(:country)}

  it 'have name' do
    expect(country).to validate_presence_of(:name)
  end

  it 'have unique name' do
    expect(country).to validate_uniqueness_of(:name)
  end

  it 'have many address' do
    expect(country).to have_many(:addresses)
  end
end
