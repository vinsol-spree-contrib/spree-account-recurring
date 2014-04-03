require 'spec_helper'

describe Spree::User do
  let(:user) { Spree::User.create!(email: 'user@test.com', password: '123456', password_confirmation: '123456') }
  let(:subscriber) { Spree::Role.create!(name: 'subscriber') }
  let(:empty_array) { [] }

  it { should have_many :subscriptions }

  describe '#find_or_create_stripe_customer' do
    let(:token) { 'stripe_test_card_token' }

    before(:each) do
      StripeMock.start
    end

    context 'when stripe customer id not present' do
      before(:each) do
        user.update_column(:stripe_customer_id, nil)
      end

      it 'should create customer' do
        Stripe::Customer.all.should be_blank
        user.find_or_create_stripe_customer(token)
        Stripe::Customer.all.should be_present
      end

      it 'should return customer' do
        customer = user.find_or_create_stripe_customer(token)
        customer.is_a?(Stripe::Customer)
      end

      it 'should assign customer id to user' do
        customer = user.find_or_create_stripe_customer(token)
        user.stripe_customer_id.should eq(customer.id)
      end
    end

    context 'when stripe customer id present' do
      let(:customer) { Stripe::Customer.create(card: token, email: user.email) }

      before(:each) do
        user.update_column(:stripe_customer_id, customer.id)
      end

      it 'should return customer' do
        user.find_or_create_stripe_customer(token).id.should eq(customer.id)
      end
    end

    after(:each) do
      StripeMock.stop
    end
  end

  describe '#api_customer' do
    let(:customer) { Stripe::Customer.create(card: 'test_token', email: user.email) }

    before(:each) do
      StripeMock.start
      user.update_column(:stripe_customer_id, customer.id)
    end

    it 'should return customer' do
      user.api_customer.id.should eq(customer.id)
    end

    after { StripeMock.stop }
  end
end