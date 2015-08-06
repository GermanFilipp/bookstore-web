FactoryGirl.define do
  factory :order do
    total_price Faker::Commerce.price
    complited_date { Faker::Time.between(6.days.ago, Time.now) }
    state "in progress"

  end

end
