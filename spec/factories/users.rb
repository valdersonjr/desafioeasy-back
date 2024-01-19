FactoryBot.define do
  factory :user do
    sequence(:login) { |n| "user#{n}" }
    sequence(:name) { |n| "name#{n}" }
    password { "123456" }
  end
end