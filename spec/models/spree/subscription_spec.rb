require 'spec_helper'

describe Spree::Subscription do
  before { StripeMock.start }
  after { StripeMock.stop }

  let!(:subscriber) { Spree::Role.create!(name: 'subscriber') }
  let(:user) { Spree::User.create!(email: 'user@test.com', password: '123456', password_confirmation: '123456') }
  let(:recurring) { Spree::Recurring::StripeRecurring.create!(name: 'Test recurring', active: true) }
  let(:plan) { recurring.plans.create!(active: true, amount: 10, interval: 'month', interval_count: 1, name: 'Test Plan', currency: 'usd', trial_period_days: 0) }
  let(:subscription) { plan.subscriptions.create!(email: user.email, user_id: user.id, card_token: 'test_card_token') }

  it { subscription.should belong_to :plan }
  it { subscription.should belong_to :user }
  it { subscription.should have_many :events }
  it { subscription.should validate_presence_of :plan_id }
  it { subscription.should validate_presence_of :email }
  it { subscription.should validate_presence_of :user_id }
  it { subscription.should validate_uniqueness_of(:plan_id).scoped_to([:user_id, :unsubscribed_at]) }
  it { subscription.should validate_uniqueness_of(:user_id).scoped_to(:unsubscribed_at) }
end