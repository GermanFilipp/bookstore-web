require 'features/features_spec_helper'
include ActionView::Helpers::NumberHelper
include OrderStepHelper
feature 'fill order step by step' do
  given(:customer) {FactoryGirl.create(:customer)}
  given!(:order) {FactoryGirl.create(:order,customer_id:customer.id, state:'in_progress', total_price:10 , delivery_price:5)}
  given!(:address) {FactoryGirl.create(:address)}
  given!(:delivery) {FactoryGirl.create(:delivery_method)}
  before do
    login_as customer
  end

  scenario 'customer view first step' do
    visit order_step_path(:address)
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


    scenario 'customer view first step' do
      visit order_step_path(:address)
      expect(page).to have_content 'BILLING ADDRESS'
      expect(page).to have_content 'SHIPPING ADDRESS'
      fill_address
      click_on 'SAVE AND CONTINUE'
      expect(page).to have_content 'DELIVERY METHOD'
    end

    scenario 'customer view second step' do
      visit order_step_path(:delivery)
      choose("#{delivery.name}")
      click_on 'SAVE AND CONTINUE'
      expect(page).to have_content 'CARD DETAILS'
    end

    scenario 'customer view third step' do

      visit order_step_path(:payment)
      expect(page).to have_content 'CARD DETAILS'

      fill_credit_card
      click_on 'SAVE AND CONTINUE'
    end


  scenario 'customer view confirm(4) step' do
    visit order_step_path(:address)
    fill_address
    click_on 'SAVE AND CONTINUE'
    choose("#{delivery.name}")
    click_on 'SAVE AND CONTINUE'
    fill_credit_card
    click_on 'SAVE AND CONTINUE'

    expect(page).to have_content 'Shipping Address'
    expect(page).to have_content 'Billing Address'
    expect(page).to have_content 'Payment information'
    expect(page).to have_content 'BOOK'
    click_on 'PLACE ORDER'
  end

  scenario 'customer view complete step' do
    visit order_step_path(:address)
    fill_address
    click_on 'SAVE AND CONTINUE'
    choose("#{delivery.name}")
    click_on 'SAVE AND CONTINUE'
    fill_credit_card
    click_on 'SAVE AND CONTINUE'
    click_on 'PLACE ORDER'
    expect(page).to have_content 'Shipping Address'
    expect(page).to have_content 'Billing Address'
    expect(page).to have_content 'Payment information'
    expect(page).to have_content 'BOOK'
    expect(page).to have_content "#{order.number}"
  end
end