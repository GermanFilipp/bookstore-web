require 'features/features_spec_helper'

feature 'Add book' do
  given(:customer) {FactoryGirl.create(:customer)}

  before do
    login_as customer
    visit orders_path
  end
  given!(:book) {FactoryGirl.create(:book,id:1,price: 10)}
 # given!(:order){FactoryGirl.create(:order,customer_id:customer.id)}
  #given!(:completed_order) {FactoryGirl.create(:already_completed,customer_id:customer.id, total_price: 20)}

  scenario 'Customer without any order' do
    expect(page).to have_content("Get started shopping!")
  end


  scenario 'Customer can see order in progress' do
    visit book_path(1)
    click_button 'Add to Cart'
    visit orders_path

    expect(page).not_to have_content("Get started shopping!")
    expect(page).to have_content("#{book.title}")
    expect(page).to have_content("#{book.price}")
  end

end