class AddStripeCustomerIdToSpreeUsers < ActiveRecord::Migration
  def change
    add_column :spree_users, :stripe_customer_id, :string
    remove_column :spree_subscription_plans, :card_customer_token
  end
end
