module Spree
  class SubscriptionEvent < Spree::Base
    serialize :response

    self.whitelisted_ransackable_associations = ['subscription_plan']

    belongs_to :subscription_plan

    validates :event_id, :subscription_plan_id, presence: true
    validates :event_id, uniqueness: true

    attr_readonly :event_id, :subscription_plan_id, :request_type
  end
end