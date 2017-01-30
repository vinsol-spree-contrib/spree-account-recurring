require 'spec_helper'

describe Spree::SubscriptionEvent do
  it "should serialize :response" do
    # Note: shoulda has a Rails5 bug for serialize bug https://github.com/thoughtbot/shoulda-matchers/issues/913
    # Added an equivalent test, can be reverted back to shoulda version when fixed
    expect(Spree::SubscriptionEvent.type_for_attribute("response")).to be_kind_of(::ActiveRecord::Type::Serialized)
  end

  it { should belong_to :subscription }
  it { should validate_presence_of :event_id }
  it { should validate_presence_of :subscription_id }
  it { should validate_uniqueness_of :event_id }
  it { should have_readonly_attribute :event_id }
  it { should have_readonly_attribute :subscription_id }
  it { should have_readonly_attribute :request_type }

  describe 'ransack' do
    it 'has subscription as ransackable association' do
      expect(Spree::SubscriptionEvent.ransackable_associations).to include('subscription')
    end
  end
end
