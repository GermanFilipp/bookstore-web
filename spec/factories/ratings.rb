FactoryGirl.define do
  factory :rating do
    review { Faker::Lorem.paragraph }
    rating 5
    customer nil
    book nil
  end

end
