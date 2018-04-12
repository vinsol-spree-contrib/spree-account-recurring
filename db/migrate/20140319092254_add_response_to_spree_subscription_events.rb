class AddResponseToSpreeSubscriptionEvents < ActiveRecord::Migration[4.2]
  def change
    add_column :spree_subscription_events, :response, :text
  end
end
