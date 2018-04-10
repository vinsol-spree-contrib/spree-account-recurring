class ChangeSubscriptionIdToSubscriptionPlanId < ActiveRecord::Migration
  def change
    rename_column :spree_subscription_events ,:subscription_id, :subscription_plan_id
  end
end
