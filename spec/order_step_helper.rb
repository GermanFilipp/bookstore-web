module OrderStepHelper
  def fill_address
    fill_in 'billing_address[first_name]',  with: Faker::Name.first_name
    fill_in 'billing_address[last_name]',   with: Faker::Name.last_name
    fill_in 'billing_address[address]',     with: Faker::Address.street_address
    fill_in 'billing_address[city]',        with: Faker::Address.city
  #  fill_in 'billing_address[country_id]',  with: 1
    fill_in 'billing_address[zipcode]',     with: Faker::Address.zip_code
    fill_in 'billing_address[phone]',       with: Faker::PhoneNumber.phone_number

    fill_in 'shipping_address[first_name]', with: Faker::Name.first_name
    fill_in 'shipping_address[last_name]',  with: Faker::Name.last_name
    fill_in 'shipping_address[address]',    with: Faker::Address.street_address
    fill_in 'shipping_address[city]',       with: Faker::Address.city
   # fill_in 'shipping_address[country_id]', with: 1
    fill_in 'shipping_address[zipcode]',    with: Faker::Address.zip_code
    fill_in 'shipping_address[phone]',      with: Faker::PhoneNumber.phone_number
  end

  def fill_credit_card
    fill_in 'credit_card[number]',          with: Faker::Business.credit_card_number
    fill_in 'credit_card[CVV]',             with: Faker::Number.number(3).to_s
=begin
    fill_in 'credit_card[expiration_month]',with: Faker::Business.credit_card_expiry_date.year
    fill_in 'credit_card[expiration_year]', with: Faker::Business.credit_card_expiry_date.month
=end
  end
end