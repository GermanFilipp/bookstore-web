FactoryGirl.define do
  factory :customer do
    email {Faker::Internet.email}
    password '12345678'
  end
end