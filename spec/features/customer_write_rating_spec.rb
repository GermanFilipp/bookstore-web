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

      fill_in 'ratings[title]' , with: "NiceBOOK"
      fill_in 'ratings[review]', with: "perfect"
      fill_in 'ratings[rating]',  with: 9
      click_button 'Submit'


    expect(page).to have_content "NiceBOOK"
    expect(page).to have_content 'perfect'
    expect(page).to have_content customer.first_name
  end

  scenario 'customer add invalid params for rating via "add rating" form' do

    fill_in 'ratings[title]' , with: "NiceBOOK"
    fill_in 'ratings[review]', with: "perfect"
    fill_in 'ratings[rating]',  with: ''
    click_button 'Submit'

    expect(page).to have_content 'Review was not added! Please fill all fields!'
  end


=begin
  should add fail add-rating
=end


end


