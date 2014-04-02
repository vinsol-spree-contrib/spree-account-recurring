class AddResponseToSpreeSubscriptionEvents < ActiveRecord::Migration
  def change
    add_column :spree_subscription_events, :response, :text
  end
end
