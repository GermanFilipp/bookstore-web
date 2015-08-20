require 'rails_helper'

RSpec.describe Book, type: :model do
  let(:book) { FactoryGirl.create(:book) }

  it 'has a title' do
    expect(book).to validate_presence_of(:title)
  end

  it 'has a price' do
    expect(book).to validate_presence_of(:price)
  end

  it 'has a quentity' do
    expect(book).to validate_presence_of(:quentity_books)
  end

  it 'has a description' do
    expect(book).to respond_to(:description)
  end

  it 'belongs to category' do
    expect(book).to belong_to(:category)
  end

  it 'belongs to author' do
    expect(book).to belong_to(:author)
  end

  it 'has many ratings' do
    expect(book).to have_many(:ratings)
  end

  describe '#by_category' do
    it 'return books by categories' do
      book1 = FactoryGirl.create(:book, category_id: 2)
      expect(Book.by_category(2)).to match_array(book1)
    end
  end
end
