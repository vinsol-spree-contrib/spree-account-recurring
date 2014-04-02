require 'stripe'
require 'stripe_tester' if Rails.env.development? || Rails.env.test?