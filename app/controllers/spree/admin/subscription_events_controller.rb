module Spree
  module Admin
    class SubscriptionEventsController < Spree::Admin::BaseController
      include RansackDateSearch
      ransack_date_searchable date_col: 'created_at'

      def index
        @search = Spree::SubscriptionEvent.ransack(params[:q])
        @subscription_events = @search.result.includes(subscription: { plan: :recurring }).references(subscription: { plan: :recurring }).page(params[:page]).per(15)
        respond_with(@subscription_events)
      end
    end
  end
end
