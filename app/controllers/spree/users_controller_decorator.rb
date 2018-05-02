Spree::UsersController.class_eval do
  before_action :load_subscription_plan, only: :show

  private

    def load_subscription_plan
      @subscription_plan = spree_current_user.subscription_plans.active.first
    end
end