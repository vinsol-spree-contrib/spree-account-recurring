class ChangeSpreeSubscriptionsToSpreeSubscriptionPlans < ActiveRecord::Migration
  def change
    rename_table :spree_subscriptions, :spree_subscription_plans
  end
end
