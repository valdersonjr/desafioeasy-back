FactoryBot.define do
  factory :user do
    sequence(:login) { |n| "user#{n}" }
    sequence(:name) { |n| "name#{n}" }
    email { Faker::Internet.email }
    password { "123456" }
    password_confirmation { "123456" }
  end
end
    

