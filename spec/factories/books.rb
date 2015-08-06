FactoryGirl.define do
  factory :book do
    title {Faker::Lorem.sentence}
    description { Faker::Lorem.paragraph }
    price { Faker::Commerce.price }
    quentity_books {Faker::Number.number(3)}
    author nil
    category nil
  end

end
