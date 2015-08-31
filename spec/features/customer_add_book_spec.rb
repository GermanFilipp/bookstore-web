require 'features/features_spec_helper'
include ActionView::Helpers::NumberHelper

feature 'Add book' do
  given(:customer) {FactoryGirl.create(:customer)}

  before do
    login_as customer
    visit book_path(book)
  end
  given!(:book) {FactoryGirl.create(:book)}

  scenario 'Customer view book' do
    expect(page).to have_content book.title
    expect(page).to have_content book.description
    expect(page).to have_content  number_to_currency book.price
    expect(page).to have_content 'Reviews'
    expect(page).to have_link 'Add Review for this book'
    expect(page).to have_content 'EMPTY'
  end

  scenario 'Customer add book to cart' do
    fill_in 'orders[quantity]', with: 3
    click_button 'Add to Cart'

    expect(page).not_to have_content 'EMPTY'
    expect(page).to have_content '(3)'
    expect(page).to have_content number_to_currency book.price*3
  end
end