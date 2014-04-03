require 'spec_helper'

describe Spree::SubscriptionEvent do
  it { should serialize :response }
  it { should belong_to :subscription }
  it { should validate_presence_of :event_id }
  it { should validate_presence_of :subscription_id }
  it { should validate_uniqueness_of :event_id }
  it { should have_readonly_attribute :event_id }
  it { should have_readonly_attribute :subscription_id }
  it { should have_readonly_attribute :request_type }
end