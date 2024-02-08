# Fábrica para criação de cargas (loads) usando o FactoryBot.

FactoryBot.define do
  factory :load do
    sequence(:code) { |n| "Load #{n}" } 
    delivery_date { Faker::Date.between(from: Date.today, to: 1.year.from_now) }
  end
end