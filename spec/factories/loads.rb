FactoryBot.define do
    factory :load do
      sequence(:name) { |n| "Load #{n}" }
    end
  end