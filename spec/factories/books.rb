FactoryGirl.define do

  factory :book do
    title {Faker::Commerce.product_name }
    description    { Faker::Commerce.product_name }
    price    { Faker::Number.number(4) }
    quentity_books { Faker::Number.number(3) }
    image {Faker::Avatar.image}
    sold_count {Faker::Number.number(3)}
    author {FactoryGirl.create(:author)}
    category_id 1
  end

end