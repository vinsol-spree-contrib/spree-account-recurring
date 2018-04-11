class CreateSpreeSubscriptionPlan < ActiveRecord::Migration
  def change
    create_table :spree_subscription_plans do |t|
      t.integer :plan_id
      t.string :email
      t.integer :user_id
      t.string :card_customer_token
      t.datetime :subscribed_at
      t.datetime :unsubscribed_at
    end

    add_index :spree_subscription_plans, :subscribed_at
    add_index :spree_subscription_plans, :unsubscribed_at
    add_index :spree_subscription_plans, :plan_id
  end
end
