FactoryBot.define do
    factory :product do
      sequence(:name) { |n| "coca #{n}" }
      sequence(:ballast) { |n| 1 + n }
    end
  end
  