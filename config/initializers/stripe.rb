require 'stripe'
require 'stripe_tester' if Rails.env.development? || Rails.env.test?

Stripe.api_version = "2018-02-28"