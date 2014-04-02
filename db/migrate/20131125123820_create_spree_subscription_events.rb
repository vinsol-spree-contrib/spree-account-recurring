class CreateSpreeSubscriptionEvents < ActiveRecord::Migration
  def change
    create_table :spree_subscription_events do |t|
      t.string :event_id
      t.integer :subscription_id
      t.string :request_type
      t.datetime :created_at, :null => false
      t.datetime :updated_at, :null => false
    end

    add_index :spree_subscription_events, :subscription_id
    add_index :spree_subscription_events, :event_id
  end
end
