require 'features/features_spec_helper'
feature 'Log in' do
  given(:customer) {FactoryGirl.create(:customer)}
  before {visit  new_customer_session_path}

  scenario 'Visitor successfully via "log in"-form' do

    within '#new_customer' do
      fill_in 'customer[email]', with: customer.email
      fill_in 'customer[password]', with: customer.password
      click_button 'Log in'
    end

    expect(page).to have_content 'Signed in successfully'
    expect(page).to have_content 'Settings'
    expect(page).to have_content 'Order'
    expect(page).to have_content 'Sign out'
    expect(page).not_to have_content 'Sign in'
    expect(page).not_to have_content 'Sign up'
    expect(page).not_to have_content 'Admin Dashboard'
  end

  scenario 'Admin successfully via "log in"-form' do

     admin = FactoryGirl.create(:customer,admin:true)
     within '#new_customer' do
       fill_in 'customer[email]', with: admin.email
       fill_in 'customer[password]', with: admin.password
       click_button 'Log in'
     end
     expect(page).to have_content 'Signed in successfully'
     expect(page).to have_content 'Settings'
     expect(page).to have_content 'Order'
     expect(page).to have_content 'Sign out'
     expect(page).not_to have_content 'Sign in'
     expect(page).not_to have_content 'Sign up'
     expect(page).to have_content 'Admin Dashboard'
  end

  scenario 'Visitor failure via "log in"-form' do

    within '#new_customer' do
      fill_in 'customer[email]', with: 'ololo@lolo.com'
      fill_in 'customer[password]', with: 'helloWorld123'
      click_button 'Log in'
    end

    expect(page).to have_content 'Invalid email or password.'
    expect(page).to have_content 'Log in'
    expect(page).to have_content 'Sign up'
    expect(page).not_to have_content 'Sign out'
    expect(page).not_to have_content 'Order'
    expect(page).not_to have_content 'Settings'
  end

end