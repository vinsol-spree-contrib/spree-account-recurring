source 'https://rubygems.org'

gem 'mysql2'

group :assets do
  gem 'coffee-rails'
  gem 'sass-rails'
end

# Provides basic authentication functionality for testing parts of your engine
gem 'spree_auth_devise', github: 'spree/spree_auth_devise', :branch => "2-1-stable"

group :test do
  gem 'shoulda-matchers'
  gem 'capybara', '~> 2.1'
  gem 'database_cleaner'
  gem 'factory_girl', '~> 4.2'
  gem 'ffaker'
  gem 'rspec-rails',  '~> 2.13'
  gem 'simplecov'
  gem 'selenium-webdriver'
end

gemspec