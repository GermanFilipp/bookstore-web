require 'features/features_spec_helper'
include ActionView::Helpers::NumberHelper

feature 'view all order items, and manipulet with them' do
  given(:customer) {FactoryGirl.create(:customer)}

  before do
    login_as customer
    visit book_path(book)
    fill_in 'orders[quantity]', with: 3
    click_button 'Add to Cart'
    click_on 'CART'
  end
  given!(:book) {FactoryGirl.create(:book)}


  scenario 'view all order_items' do
    expect(page).to have_content book.title
    expect(page).to have_content 'EMPTY CART'
    expect(page).to have_content 'CONTINUE SHOPPING'
    expect(page).to have_content 'CHECKOUT'
    expect(page).to have_content 'SUBTOTAL'
    expect(page).to have_content book.description
    expect(page).to have_content number_to_currency book.price*3
  end

  scenario 'change quantity of book' do
    fill_in "quantity[#{book.id}]", with: 5
    click_button 'UPDATE'

    expect(page).to have_content book.title
    expect(page).to have_content number_to_currency book.price*5
  end

  scenario 'click on EMPTY CART' do
    click_on 'EMPTY CART'

    expect(page).not_to have_content book.title
    expect(page).not_to have_content 'SUBTOTAL'
    expect(page).not_to have_content book.description
    expect(page).to have_content 'Shopping cart is empty... Get started shopping!'
  end

  scenario 'click on CONTINUE SHOPPING' do
    click_on 'CONTINUE SHOPPING'

    expect(page).to have_content book.title
    expect(page).to have_content number_to_currency book.price
    expect(page).to have_content number_to_currency book.price*3
    expect(page).not_to have_content 'EMPTY'
  end

end