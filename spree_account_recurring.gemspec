# encoding: UTF-8
Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_account_recurring'
  s.version     = '1.0.0'
  s.summary     = 'Account Recurrring for Spree Commerce'
  s.description = s.summary
  s.required_ruby_version = '>= 1.9.3'

  s.author    = 'Priyank Gupta'
  s.email     = 'priyank.gupta@vinsol.com'
  s.homepage  = 'http://www.vinsol.com'

  s.files     = Dir['LICENSE', 'README.md', 'app/**/*', 'config/**/*', 'lib/**/*', 'db/**/*']
  s.require_path = 'lib'
  s.requirements << 'none'

  s.add_dependency 'spree_core', '~> 2.1'
  s.add_dependency 'stripe', '1.10.1'
  s.add_dependency 'stripe_tester'

  s.add_development_dependency 'capybara', '~> 2.1'
  s.add_development_dependency 'factory_girl', '~> 4.2'
  s.add_development_dependency 'rspec-rails',  '~> 2.13'
  s.add_development_dependency 'shoulda-matchers'
  s.add_development_dependency 'spree_auth_devise'
  s.add_development_dependency 'simplecov'
end
