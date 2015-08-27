require 'features/features_spec_helper'

feature 'Customer writes rating' do


  given(:customer) { FactoryGirl.create(:customer)}
  before do
    login_as customer
    visit new_book_rating_path(book)
  end
  given!(:book) {FactoryGirl.create(:book)}
  given!(:rating) {FactoryGirl.create(:rating)}


  scenario 'customer on "add rating" form' do
    expect(page).to have_content "New review for #{book.title}"
  end

  scenario 'customer add rating via "add rating" form' do

  end



end


