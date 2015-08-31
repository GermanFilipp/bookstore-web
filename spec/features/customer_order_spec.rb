require 'features/features_spec_helper'
include ActionView::Helpers::NumberHelper

feature 'fill order step by step' do
  given(:customer) {FactoryGirl.create(:customer)}
  given!(:order) {FactoryGirl.create(:order, state:'in_progress')}
  given!(:address) {FactoryGirl.create(:address)}
  before do
    login_as customer
    visit order_step_path(:address)
  end

  scenario 'customer view first step' do
    expect(page).to have_content 'Checkout'
    expect(page).to have_content 'ADDRESS'
    expect(page).to have_content 'DELIVERY'
    expect(page).to have_content 'PAYMENT'
    expect(page).to have_content 'CONFIRM'
    expect(page).to have_content 'COMPLETE'
    expect(page).to have_content 'BILLING ADDRESS'
    expect(page).to have_content 'SHIPPING ADDRESS'
    expect(page).to have_content 'ORDERS SUMMARY'
    expect(page).to have_content 'SAVE AND CONTINUE'
    expect(page).to have_content number_to_currency order.total_price
  end

  feature 'fill order step by step' do
    scenario 'customer view first step' do
    within '#show(:address)' do
      fill_in 'billing_address[first_name]', with: address.first_name
      fill_in 'billing_address[last_name]', with: address.last_name
      fill_in 'billing_address[address]', with: address.address
      fill_in 'billing_address[city]', with: address.city
      fill_in 'billing_address[country_id]', with: 1
      fill_in 'billing_address[phone]', with: address.phone
      fill_in 'use_billing_address'
      click_on 'SAVE AND CONTINUE'
    end

    expect(page).to have_content 'DELIVERY METHOD'
      end
  end
end