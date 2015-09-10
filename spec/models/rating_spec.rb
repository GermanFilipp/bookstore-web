require 'rails_helper'

RSpec.describe Rating, type: :model do
  let(:rating) {FactoryGirl.create(:rating)}

  it 'belongs to customer' do
    expect(rating).to belong_to(:customer)
  end

  it 'belongs to book' do
    expect(rating).to belong_to(:book)
  end

  it 'has a review' do
    expect(rating).to validate_presence_of(:review)
  end
  it 'has a rating' do
    expect(rating).to validate_presence_of(:rating)
  end

  it 'has an integer rating' do
    expect(rating.rating).to be_a_kind_of(Integer)
  end

  it 'has rating which is between 1 to 10' do
    expect(rating.rating).to be_between(1,10)
  end

  it 'has a title' do
    expect(rating).to validate_presence_of(:title)
  end

  describe '#get_rating' do
    it 'must return review for current book' do
      book = FactoryGirl.create(:book)
             FactoryGirl.create(:rating, book:book)
             FactoryGirl.create(:rating, book:book)
      expect(Rating.get_rating(book).length).to eq(2)
    end

  end




end
