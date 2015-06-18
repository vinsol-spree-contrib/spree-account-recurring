module Spree
  class Plan < Spree::Base
    module ApiHandler
      extend ActiveSupport::Concern

      included do
        before_validation :set_api_plan_id, on: :create
        after_create :create_plan
        after_update :delete_plan, :if => [:deleted_at_changed?, :deleted_at?]
        after_update :update_plan, :if => :name_changed?
      end

      def create_plan
        provider.create_plan(self)
      end

      def delete_plan
        provider.delete_plan(self)
      end

      def update_plan
        provider.update_plan(self)
      end

      def save_and_manage_api(*args)
        begin
          new_record? ? save : update_attributes(*args)
        rescue provider.error_class, ActiveRecord::RecordNotFound => e
          logger.error "Error: #{e.message}"
          errors.add :base, e.message
          false
        end
      end

      def provider
        recurring.present? ? recurring : (raise ActiveRecord::RecordNotFound.new("Provider not found."))
      end

      private

      def set_api_plan_id
        provider.set_api_plan_id(self)
      end
    end
  end
end