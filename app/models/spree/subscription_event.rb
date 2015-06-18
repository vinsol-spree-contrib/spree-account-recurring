module Spree
  class SubscriptionEvent < Spree::Base
    serialize :response
    
    belongs_to :subscription
    validates :event_id, :subscription_id, presence: true
    validates :event_id, uniqueness: true

    attr_readonly :event_id, :subscription_id, :request_type
  end
end