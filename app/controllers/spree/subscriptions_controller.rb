module Spree
  class SubscriptionsController < StoreController
    prepend_before_filter :load_object
    before_action :find_active_plan, only: [:new, :create]
    before_action :find_plan, only: [:show, :destroy]
    before_action :find_subscription, only: [:show, :destroy]
    before_action :authenticate_subscription, only: [:new, :create]

    def new
      @subscription = @plan.subscriptions.build
    end

    def create
      @subscription = @plan.subscriptions.build(subscription_params.merge(user_id: spree_current_user.id))
      if @subscription.save_and_manage_api
        redirect_to recurring_plan_subscription_url(@plan, @subscription), notice: "Thank you for subscribing!"
      else
        render :new
      end
    end

    def destroy
      if @subscription.save_and_manage_api(unsubscribed_at: Time.current)
        redirect_to recurring_plans_path, notice: "Subscription has been cancelled."
      else
        render :show
      end
    end

    private

    def find_active_plan
      unless @plan = Spree::Plan.active.where(id: params[:plan_id]).first
        flash[:error] = "Plan not found."
        redirect_to recurring_plans_url
      end
    end

    def find_plan
      unless @plan = Spree::Plan.where(id: params[:plan_id]).first
        flash[:error] = "Plan not found."
        redirect_to recurring_plans_url
      end
    end

    def find_subscription
      unless @subscription = @plan.subscriptions.undeleted.where(id: params[:id]).first
        flash[:error] = "Subscription not found."
        redirect_to root_url
      end
    end

    def subscription_params
      params.require(:subscription).permit(:email, :card_token)
    end

    def load_object
      @user ||= spree_current_user
      authorize! params[:action].to_sym, @user
    end

    def authenticate_subscription
      if subscription = spree_current_user.subscriptions.undeleted.first
        flash[:alert] = "You have already subscribed."
        redirect_to recurring_plan_subscription_url(@plan, subscription)
      end
    end
  end
end