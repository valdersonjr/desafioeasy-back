FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { "123456" }
    password_confirmation { "123456" }
    sequence(:login) { |n| "userrrrr#{n}" }
  end
end
    

