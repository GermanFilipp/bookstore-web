FactoryGirl.define do
  factory :category do
    title {Faker::Commerce.product_name}

  end
end