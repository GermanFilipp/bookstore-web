require 'features/features_spec_helper'
include ActionView::Helpers::NumberHelper
include OrderStepHelper
feature 'fill order step by step' do
  given(:customer) {FactoryGirl.create(:customer)}
  given!(:order) {FactoryGirl.create(:order,customer_id:customer.id, state:'in_progress', total_price:10 , delivery_price:5)}
  given!(:book){FactoryGirl.create(:book)}
  given!(:country){FactoryGirl.create(:country)}
  given!(:delivery) {FactoryGirl.create(:delivery_method)}
  before do
    login_as customer
  end

    scenario 'customer view address step' do
      visit order_step_path(:address)
      fill_address
      click_button 'SAVE AND CONTINUE'
      expect(current_path).to eq(order_step_path(:delivery))
    end

    scenario 'customer view delivery step' do
      visit order_step_path(:delivery)
      choose delivery.name
      click_button 'SAVE AND CONTINUE'
      expect(current_path).to eq(order_step_path(:payment))

    end

    scenario 'customer view credit_card step' do
      order.update(billing_address: FactoryGirl.create(:address),
                   shipping_address: FactoryGirl.create(:address),
                   delivery_method: FactoryGirl.create(:delivery_method))
      visit order_step_path(:payment)
      fill_credit_card
      click_button 'SAVE AND CONTINUE'
      expect(current_path).to eq(order_step_path(:confirm))
    end





  scenario 'customer view confirm step' do
    fill_all_fields
    visit order_step_path(:confirm)
    expect(page).to have_content order.billing_address.address
    expect(page).to have_content order.shipping_address.address
    expect(page).to have_content order.delivery_method.name
    expect(page).to have_content order.credit_card.expiration_year
    expect(page).to have_content order.credit_card.number.to_s.slice(-4..-1)
  end

  scenario 'customer view complete step' do
    fill_all_fields
    order.checkout!
    visit order_step_path(:complete)
    expect(page).to have_content order.billing_address.address
    expect(page).to have_content order.shipping_address.address
    expect(page).to have_content order.delivery_method.name
    expect(page).to have_content order.credit_card.expiration_year
    expect(page).to have_content order.credit_card.number.to_s.slice(-4..-1)
  end


  def fill_all_fields
    order.update(billing_address: FactoryGirl.create(:address),
                 shipping_address: FactoryGirl.create(:address),
                 delivery_method: create(:delivery_method),
                 credit_card: FactoryGirl.create(:credit_card))
  end
end