FactoryGirl.define do
  factory :order_item do
    price { Faker::Commerce.price }
    quantity { Faker::Number.number(1) }
    book nil
    order nil
  end

end
