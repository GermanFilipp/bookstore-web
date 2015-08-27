require 'features/features_spec_helper'
include ActionView::Helpers::NumberHelper

feature 'Customer view short description of the books' do
  given(:customer) { FactoryGirl.create(:customer)}
  before do
    login_as customer
  end
  given!(:book) {FactoryGirl.create(:book)}
  given!(:rating) {FactoryGirl.create(:rating, book: book)}


  scenario 'Customer view book' do
    visit book_path(book.id)

    expect(page).to have_content book.title
    expect(page).to have_content book.description
    expect(page).to have_content  number_to_currency book.price
    #expect(page).to have_button "Add Review"
    expect(page).to have_content 'Reviews'
    expect(page).to have_link 'Add Review for this book'
    expect(page).to have_content rating.title
    expect(page).to have_content rating.review
    expect(page).to have_content rating.rating
  end

end