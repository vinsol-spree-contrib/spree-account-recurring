module Spree
  module Admin
    class SubscriptionEventsController < Spree::Admin::BaseController
      include RansackDateSearch
      ransack_date_searchable date_col: 'created_at'

      def index
        @search = Spree::SubscriptionEvent.ransack(params[:q])
        @subscription_events = @search.result.includes(subscription_plan: { plan: :recurring }).references(subscription_plan: { plan: :recurring }).page(params[:page]).per(15)
        respond_with(@subscription_events)
      end
    end
  end
end
