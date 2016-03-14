source 'https://rubygems.org'

gem 'sqlite3'

group :assets do
  gem 'coffee-rails'
  gem 'sass-rails'
end

# Provides basic frontend and backend functionalities for testing purposes
gem 'spree', github: 'spree/spree', branch: 'master'

# Provides basic authentication functionality for testing parts of your engine
gem 'spree_auth_devise', github: 'spree/spree_auth_devise', branch: 'master'

group :test do
  gem 'shoulda-matchers', '~> 2.8.0'
  gem 'capybara', '~> 2.1'
  gem 'database_cleaner'
  gem 'factory_girl', '~> 4.2'
  gem 'ffaker'
  #gem 'rspec-rails',  '~> 2.13'
  gem 'simplecov'
  gem 'selenium-webdriver'
  gem 'stripe-ruby-mock', '1.10.1.2'
end

gemspec
