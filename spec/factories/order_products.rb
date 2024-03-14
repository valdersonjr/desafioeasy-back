FactoryBot.define do
  factory :order_product do
    association :order
    association :product
    sequence(:quantity) { |n| "#{n} caixas" } 
    box { [true, false].sample }
  end
end