module Spree
  module Admin
    module RansackDateSearch
      extend ActiveSupport::Concern

      module ClassMethods
        def ransack_date_searchable(options={})
          raise ArgumentError, "Hash expected, got #{options.class.name}" unless options.is_a?(Hash)
          class_attribute :ransack_date_search_config, :ransack_date_search_col_ref, :ransack_date_search_param_gt, :ransack_date_search_param_lt
          self.ransack_date_search_config = { date_col: "created_at" }.merge!(options)
          # self.ransack_date_search_config[:before_action] = [ransack_date_search_config[:before_action]] unless ransack_date_search_config[:before_action].is_a?(Array)
          self.ransack_date_search_col_ref = ransack_date_search_config[:date_col]
          self.ransack_date_search_param_gt = "#{ransack_date_search_col_ref}_gt"
          self.ransack_date_search_param_lt = "#{ransack_date_search_col_ref}_lt"
        end
      end

      included do
        before_action :parse_ransack_date_search_param!, only: 'index'
      end
      
      private

      def parse_ransack_date_search_param!
        params[:q] = {} unless params[:q]
        parse_ransack_date_search_param_gt!
        parse_ransack_date_search_param_lt!
        params[:q][:s] ||= "#{ransack_date_search_col_ref} desc"
        params[:q].delete_if{ |k, v| v.blank? }
      end

      def parse_ransack_date_search_param_gt!
        if params[:q][ransack_date_search_param_gt].blank?
          params[:q][ransack_date_search_param_gt] = Time.current.beginning_of_month
        else
          params[:q][ransack_date_search_param_gt] = Time.zone.parse(params[:q][ransack_date_search_param_gt]).beginning_of_day rescue Time.current.beginning_of_month
        end
      end

      def parse_ransack_date_search_param_lt!
        if params[:q][ransack_date_search_param_lt].present?
          params[:q][ransack_date_search_param_lt] = Time.zone.parse(params[:q][ransack_date_search_param_lt]).end_of_day rescue ""
        end
      end
    end
  end
end