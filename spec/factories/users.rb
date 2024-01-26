FactoryBot.define do
  factory :user do
    transient do
      custom_id { User.next_available_id }
    end

    id { custom_id }
    sequence(:login) { |n| "user#{n}" }
    sequence(:name) { |n| "name#{n}" }
    password { "123456" }

    after(:build) do |user, evaluator|
      user.id = evaluator.custom_id
    end
  end
end