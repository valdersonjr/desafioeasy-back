FactoryBot.define do
    factory :load do
      sequence(:code) { |n| "Load #{n}" }
      sequence(:delivery_date) { |n| "Date #{n}" }
    end
  end