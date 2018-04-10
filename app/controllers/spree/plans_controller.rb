module Spree
  class PlansController < StoreController
    before_action :load_user_subscriptions

    def index
      @plans = Spree::Plan.visible.order('id desc')
    end

    private
      def load_user_subscriptions
        if spree_current_user
          @user_subscriptions = spree_current_user.subscription_plans.undeleted.all.to_a
        else
          @user_subscriptions = []
        end
      end
  end
end
