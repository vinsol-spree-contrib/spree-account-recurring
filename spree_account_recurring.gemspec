# encoding: UTF-8
Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_account_recurring'
  s.version     = '2.1.0'
  s.summary     = 'Spree extension to manage recurring payments/subscriptions using Stripe Payment Gateway.'
  s.description = s.summary
  s.required_ruby_version = '>= 2.1.0'

  s.author    = 'Priyank Gupta'
  s.email     = 'info@vinsol.com'
  s.homepage  = 'http://vinsol.com'

  s.files     = Dir['LICENSE', 'README.md', 'app/**/*', 'config/**/*', 'lib/**/*', 'db/**/*']
  s.require_path = 'lib'
  s.requirements << 'none'

  s.add_dependency 'spree_core', '~> 3.1.0'
  s.add_dependency 'stripe', '3.12.1'
  s.add_dependency 'stripe_tester'

  s.add_development_dependency 'rspec-rails',  '~> 3.4'
end
