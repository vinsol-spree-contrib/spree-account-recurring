module Spree
  module Admin
    class RecurringsController < Spree::Admin::BaseController
      before_action :find_recurring, :only => [:edit, :update, :destroy]
      before_action :build_recurring, :only => :create

      def index
        @recurrings = Spree::Recurring.undeleted.order('id desc')
      end

      def new
        @recurring = Spree::Recurring.new
      end

      def create
        if @recurring.save
          flash[:notice] = "Recurring created succesfully."
          redirect_to edit_admin_recurring_url(@recurring)
        else
          render :new
        end
      end

      def update
        if @recurring.update_attributes(recurring_params(:update))
          flash[:notice] = "Recurring updated succesfully."
          redirect_to edit_admin_recurring_url(@recurring)
        else
          render :edit
        end
      end

      def destroy
        @recurring.restrictive_destroy
      end

      private

      def find_recurring
        unless @recurring = Spree::Recurring.undeleted.where(id: params[:id]).first
          flash[:error] = "Recurring not found."
          respond_to do |format|
            format.html {redirect_to admin_recurrings_url}
            format.js { }
          end
        end
      end

      def recurring_params(action=:create)
        if action == :create
          params.require(:recurring).permit(:name, :type, :description, :active)
        else
          params.require(:recurring).permit(:name, :description, :active).merge(preference_params)
        end
      end

      def build_recurring
        @recurring = recurring_params.delete(:type).constantize.new(recurring_params)
      end

      def preference_params
        params[ActiveModel::Naming.param_key(@recurring)]
      end
    end
  end
end