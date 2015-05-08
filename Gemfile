ruby '2.1.5'
source "https://rubygems.org"

gem 'dotenv'
gem 'puma', '~> 2.0'

gem 'virtus'
gem 'tumblr_client'
gem 'nokogiri'
gem 'sidekiq'#, '~> 2.3.3'
gem 'sidekiq-status', github: 'utgarda/sidekiq-status'

gem 'rack'
gem 'sinatra'
gem 'sinatra-contrib'
gem 'omniauth-tumblr'
gem 'multi_json'

gem 'rake'
gem 'pry', group: %w(development test), require: false

group :development do
  gem 'foreman'
  gem 'shotgun'
end

group :test do
  gem 'rspec'
  gem 'factory_girl', '~> 4.0'
  gem 'fuubar', require: false
  gem 'codeclimate-test-reporter', require: false
end
