require 'rails_helper'

RSpec.describe Category, type: :model do
  let(:category) {FactoryGirl.create :category}


  it 'has a title' do
    expect(category).to validate_presence_of(:title)
  end

  it 'has unique title' do
    expect(category).to validate_uniqueness_of(:title)
  end


  it 'has many books' do
    expect(category).to have_many(:books)
  end

end
