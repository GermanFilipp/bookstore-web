FactoryGirl.define do
  factory :customer do
    email {Faker::Internet.email}
    password '12345678'



  factory :facebook_customer do
    provider "facebook"
    uid { Faker::Number.number(15) }
  end


  end
end