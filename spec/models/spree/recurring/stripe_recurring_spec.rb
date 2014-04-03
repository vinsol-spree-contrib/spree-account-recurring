require 'spec_helper'

describe Spree::Recurring::StripeRecurring do
  let(:stripe_recurring) { Spree::Recurring::StripeRecurring.create!(name: 'Test recurring', active: true) }

  it { Spree::Recurring::StripeRecurring::WEBHOOKS.should eq(['customer.subscription.deleted', 'customer.subscription.created', 'customer.subscription.updated', 'invoice.payment_succeeded', 'invoice.payment_failed', 'charge.succeeded', 'charge.failed', 'charge.refunded', 'charge.captured', 'plan.created', 'plan.updated', 'plan.deleted']) }
  it { Spree::Recurring::StripeRecurring::INTERVAL.should eq({ week: 'Weekly', month: 'Monthly', year: 'Annually' }) }
  it { Spree::Recurring::StripeRecurring::CURRENCY.should eq({ usd: 'USD', gbp: 'GBP', jpy: 'JPY', eur: 'EUR', aud: 'AUD', hkd: 'HKD', sek: 'SEK', nok: 'NOK', dkk: 'DKK', pen: 'PEN', cad: 'CAD'})}

  describe '#before_each' do
    before(:each) do
      stripe_recurring.stub(:preferred_secret_key).and_return('test_secret_key')
    end

    it 'should return set_api_key' do
      Stripe.api_key.should be_nil
      stripe_recurring.before_each
      Stripe.api_key.should eq('test_secret_key')
    end
  end
end