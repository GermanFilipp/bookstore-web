require 'features/features_spec_helper'

feature 'Visitor registers failure via register form' do
  before {visit new_customer_registration_path}
  given(:customer) { build(:customer) }

  scenario 'click sign up with blank fields' do
    expect {click_button('Sign up')}.not_to change(Customer,:count)
    expect(page).to_not have_content 'Sign out'
    expect(page).to have_content 'Sign up'
  end

  scenario 'Visitor registers successfully via register form' do
    visit new_customer_registration_path

    within '#new_customer' do
      fill_in 'customer[email]', with: customer.email
      fill_in 'Password',   with: '1234567890'
      fill_in 'Password confirmation', with:  '1234567890'
      click_on 'Sign up'
    end

    expect(page).to_not have_content 'Sign up'
    expect(page).to have_content 'Sign out'
    expect(page).to have_content 'Welcome! You have signed up successfully.'

  end
end