module Spree
  module Admin
    class SubscriptionsController < Spree::Admin::BaseController
      include RansackDateSearch
      ransack_date_searchable date_col: 'subscribed_at'

      def index
        @search = Spree::Subscription.ransack(params[:q])
        @subscriptions = @search.result.includes(plan: :recurring).references(plan: :recurring).page(params[:page]).per(15)
        respond_with(@subscriptions)
      end
    end
  end
end
