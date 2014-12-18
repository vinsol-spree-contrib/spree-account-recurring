module Spree
  class Recurring < Spree::Base
    class StripeRecurring < Spree::Recurring
      module ApiHandler
        extend ActiveSupport::Concern

        included do
          include BeforeEach
          include PlanApiHandler
          include SubscriptionApiHandler
          include SubscriptionEventApiHandler
        end

        def error_class
          Stripe::InvalidRequestError
        end

        def raise_invalid_object_error(object, type)
          raise error_class.new("Not a valid object.") unless object.is_a?(type)
        end

        def set_api_key
          Stripe.api_key = preferred_secret_key
        end
      end
    end
  end
end