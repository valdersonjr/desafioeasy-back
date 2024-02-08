# Fábrica para criação de usuários (users) usando o FactoryBot.

FactoryBot.define do
  factory :user do
    sequence(:id) { |n| "#{n}" }
    sequence(:login) { |n| "user#{n}" }
    sequence(:name) { |n| "name#{n}" }
    password { "123456" }
  end
end