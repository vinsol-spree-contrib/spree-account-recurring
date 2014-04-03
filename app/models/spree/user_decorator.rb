Spree::User.class_eval do
  has_many :subscriptions

  def find_or_create_stripe_customer(token)
    return api_customer if stripe_customer_id?
    customer = Stripe::Customer.create(description: email, email: email, card: token)
    update_column(:stripe_customer_id, customer.id)
    customer
  end

  def api_customer
    Stripe::Customer.retrieve(stripe_customer_id)
  end
end