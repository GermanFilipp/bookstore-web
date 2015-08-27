require 'features/features_spec_helper'
include ActionView::Helpers::NumberHelper

feature 'View all books' do
  given(:customer) { FactoryGirl.create(:customer) }
  given!(:books) {create_list(:book,8)}
  before do
    login_as customer
  end


  scenario 'Visitor view all books' do
    visit books_path

    expect(page).to have_content 'SHOP BY CATEGORIES'

    (books).each do |book|
      expect(page).to have_content book.title
      expect(page).to have_content  number_to_currency book.price
    end

  end
end