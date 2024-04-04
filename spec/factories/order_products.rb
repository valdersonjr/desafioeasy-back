FactoryBot.define do
  factory :order_product do
    association :order
    association :product
    sequence(:quantity) { |n| 1 + n }
    box { [true, false].sample }
  end
end