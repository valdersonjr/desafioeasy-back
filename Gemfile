source "https://rubygems.org"

ruby "3.3.0"

gem "rails", "~> 7.1.2"
gem "pg", "~> 1.1"
gem "puma", ">= 5.0"
gem "tzinfo-data", platforms: %i[ windows jruby ]
gem "bootsnap", require: false
gem "rack-cors"
gem 'will_paginate'
gem 'ransack'
gem 'jbuilder'
gem 'activerecord-import'
gem 'sidekiq'
gem 'redis'
gem 'redis-client'
gem "faker"

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"


#Auth
gem 'devise'
gem 'devise-jwt'

group :development, :test do
  gem "debug", platforms: %i[ mri windows ]
  gem "rspec-rails"
  gem "factory_bot_rails"
  gem 'shoulda-matchers'
end

group :development do
  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
end
