FactoryGirl.define do
  factory :rating do
    customer {FactoryGirl.create(:customer)}
    book {FactoryGirl.create(:book)}
    title {Faker::Name.title}
    review {Faker::Lorem.sentence}
    rating {Faker::Number.between(1, 10)}
  end
end