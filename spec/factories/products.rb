FactoryBot.define do
    factory :product do
      sequence(:name) { |n| "coca #{n}" }
      sequence(:ballast) { |n| 1 + n }
      image { Rack::Test::UploadedFile.new(Rails.root.join("spec/support/images/coca_image.png")) }
    end
  end
  