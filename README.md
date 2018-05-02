Spree Account Recurring [![Code Climate](https://codeclimate.com/github/vinsol/spree-account-recurring.png)](https://codeclimate.com/github/vinsol/spree-account-recurring) [![Build Status](https://travis-ci.org/vinsol/spree-account-recurring.svg?branch=master)](https://travis-ci.org/vinsol/spree-account-recurring)
=========================

Spree extension to manage recurring payments/subscriptions using [Stripe Payment Gateway](https://stripe.com/).

All plans and subscription scenarios are been managed as per [Stripe Docs](https://stripe.com/docs/api)

Demo
----
Try Spree Account Recurring for Spree master with direct deployment on Heroku:

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy?template=https://github.com/vinsol-spree-contrib/spree-demo-heroku/tree/spree-account-recurring-master)

Try Spree Account Recurring for Spree 3-4 with direct deployment on Heroku:

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy?template=https://github.com/vinsol-spree-contrib/spree-demo-heroku/tree/spree-account-recurring-3-4)


Try Spree Account Recurring for Spree 3-1 with direct deployment on Heroku:

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy?template=https://github.com/vinsol-spree-contrib/spree-demo-heroku/tree/spree-account-recurring-3-1)

Installation
------------

Install `spree_account_recurring` by adding the following to your `Gemfile`:

```ruby
# Spree >= 3.2
gem 'spree_account_recurring', github: 'vinsol-spree-contrib/spree-account-recurring',  branch: 'master'
```

```ruby
# Spree 3.1.x
gem 'spree_account_recurring', github: 'vinsol-spree-contrib/spree-account-recurring',  branch: '3-1-stable'
```

```ruby
# Spree 3.0.x
gem 'spree_account_recurring', '~> 2.0'
```

```ruby
# Spree 2.4.x
gem 'spree_account_recurring', '~> 1.3'
```

For older version of Spree

```ruby
# Spree 2.3.x
gem 'spree_account_recurring', '~> 1.2'

# Spree 2.2.x
gem 'spree_account_recurring', '~> 1.1'

# Spree 2.1.x
gem 'spree_account_recurring', '~> 1.0'
```


Bundle your dependencies and run the installation generator:

```shell
bundle
bundle exec rails g spree_account_recurring:install
```

Usage
-----

This gem is used to create plans, which can be subscribed by a user, and it will charge the user automatically through Stripe. Currently, we are supporting one active subscription per user at one time.

At Admin end this will add a configuration tab as "Recurring".

* Creating a Recurring Provider:
  * Create a recurring using `Spree::Recurring::StripeRecurring` Provider and save
  * Add secret key and public key provided by [stripe](https://stripe.com/) to this recurring.

* Creating Plans for Recurring Provider:
  * Go to "Manage Plans" from Recurring edit page.
  * Create a plan by specifying respective details. This will create the same plan on your stripe account.
  * Only name can be updated for a plan.

One Recurring Provider can have multiple plans.

At Front end you can view all plans here: `http://your.domain.name/plans`

* Subscribe a plan:
  * Click subscribe for any plan.
  * Fill in credit card details and submit.
  * This will create a customer in Stripe for user and subscribe that user respective to plan.

* Unsubscribe a plan:
  * In plans page subscribed plan will be listed and from there user can unsubscribe from plan.

At Admin, all subscriptions can be seen under "Reports" -> "Subscriptions".

Stripe Webhook
--------------

Create a webhook at stripe with url `http://your.domain.name/recurring_hooks/handler` which will receive below mentioned stripe event hooks.

Events:
* `customer.subscription.created`
* `customer.subscription.updated`
* `invoice.payment_succeeded`
* `charge.succeeded`

These events can be viewed at admin in "Reports" -> "Subscription Events"

Testing
-------

Be sure to bundle your dependencies and then create a dummy test app for the specs to run against.

```shell
bundle
bundle exec rake test_app
bundle exec rspec spec
```

When testing your applications integration with this extension you may use it's factories.
Simply add this require statement to your spec_helper:

```ruby
require 'spree_account_recurring/factories'
```

Contributing
------------

1. Fork the repo.
2. Clone your repo.
3. Run `bundle install`.
4. Run `bundle exec rake test_app` to create the test application in `spec/test_app`.
5. Make your changes.
6. Ensure specs pass by running `bundle exec rspec spec`.
7. Submit your pull request.


Credits
-------

[![vinsol.com: Ruby on Rails, iOS and Android developers](http://vinsol.com/vin_logo.png "Ruby on Rails, iOS and Android developers")](http://vinsol.com)

Copyright (c) 2014 [vinsol.com](http://vinsol.com "Ruby on Rails, iOS and Android developers"), released under the New MIT License
