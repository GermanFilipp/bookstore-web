require 'features/features_spec_helper'
include ActionView::Helpers::NumberHelper

feature 'View books by category' do

  given(:customer) { FactoryGirl.create(:customer)}
  given!(:category) { FactoryGirl.create(:category)}

  given!(:books) {create_list(:book,8,category: category)}
  before do
    login_as customer
  end

  scenario 'Customer view books by category' do
    visit category_path(category.id)

    expect(page).to have_content "Categories - #{category.title}"
    (books).each do |book|
      expect(page).to have_content book.title
      expect(page).to have_content  number_to_currency book.price
    end
  end
end