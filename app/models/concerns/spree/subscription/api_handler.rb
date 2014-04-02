module Spree
  class Subscription < ActiveRecord::Base
    module ApiHandler
      extend ActiveSupport::Concern

      included do
        attr_accessor :card_token
        before_create :subscribe
        before_update :unsubscribe, :if => [:unsubscribed_at_changed?, :unsubscribed_at?]
      end

      def subscribe
        provider.subscribe(self)
        self.subscribed_at = Time.current
      end

      def unsubscribe
        provider.unsubscribe(self)
      end

      def save_and_manage_api(*args)
        begin
          new_record? ? save : update_attributes(*args)
        rescue provider.error_class, ActiveRecord::RecordNotFound => e
          logger.error "Error while subscribing: #{e.message}"
          errors.add :base, "There was a problem with your credit card"
          false
        end
      end

      def provider
        plan.try(:recurring).present? ? plan.recurring : (raise ActiveRecord::RecordNotFound.new("Provider not found."))
      end

      private
    end
  end
end