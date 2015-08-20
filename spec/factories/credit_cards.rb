FactoryGirl.define do
  factory :credit_card do
    number { Faker::Business.credit_card_number }
    CVV { Faker::Number.number(3).to_s }
    expiration_year do
      first_year = Time.zone.now.year
      last_year = first_year+7
      rand(first_year..last_year)
    end
    expiration_month { Faker::Business.credit_card_expiry_date.month }
    first_name {Faker::Name.name}
    last_name {Faker::Name.name}
  end
end