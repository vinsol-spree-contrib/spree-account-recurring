module Spree
  class Recurring < Spree::Base
    class StripeRecurring < Spree::Recurring
      module ApiHandler
        module SubscriptionApiHandler
          def subscribe(subscription_plan)
            raise_invalid_object_error(subscription_plan, Spree::SubscriptionPlan)
            customer = subscription_plan.user.find_or_create_stripe_customer(subscription_plan.card_token)
            # subscriptions is on Stripe customer, no changes here
            stripe_subscription = customer.subscriptions.create(plan: subscription_plan.api_plan_id)
            subscription_plan.stripe_subscription_id =  stripe_subscription.id # add stripe subscription id to subscription
          end

          def unsubscribe(subscription_plan)
            raise_invalid_object_error(subscription_plan, Spree::SubscriptionPlan)
            # subscriptions is on Stripe customer, no changes here
            subscription_plan.user.api_customer.cancel_subscription
          end
        end
      end
    end
  end
end