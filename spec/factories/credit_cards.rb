FactoryGirl.define do
  factory :credit_card do
    CVV { Faker::Number.number(4) }
    number { Faker::Number.number(10) }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    expiration_month { Faker::Number.number(2) }
    expiration_year { Faker::Number.number(4) }
    customer nil
  end

end
