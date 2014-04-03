require 'spec_helper'

describe Spree::User do
  let(:user) { Spree::User.create!(email: 'user@test.com', phone: '125') }
  let(:subscriber) { Spree::Role.create!(name: 'subscriber') }
  let(:empty_array) { [] }

  it { should have_many :subscriptions }
end