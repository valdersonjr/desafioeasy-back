FactoryBot.define do
  factory :order do
    sequence(:code) { |n| "CODE#{n}" }
    sequence(:bay) { |n| "BAY#{n}" }
    association :load
  end
end