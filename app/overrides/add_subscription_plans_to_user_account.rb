Deface::Override.new(virtual_path: 'spree/users/show',
  name: 'add_subscription_plans_to_users_account',
  insert_before: '[data-hook="account_my_orders"]',
  partial: 'spree/users/subscription_plan'
)