module Spree
  class Subscription < Spree::Base
    module RoleSubscriber
      extend ActiveSupport::Concern

      included do
        before_create :add_role_subscriber, :unless => :unsubscribed_at?
        before_update :remove_role_subscriber, :if => :unsubscribed_at?
      end

      def add_role_subscriber
        if role = subscriber_role
          user.spree_roles << role
        else
          errors.add :base, "Subscriber role is not present."
          false
        end
      end

      def remove_role_subscriber
        if role = subscriber_role
          user.spree_roles.destroy(role)
        else
          errors.add :base, "Subscriber role is not present."
          false
        end
      end

      private

      def subscriber_role
        Spree::Role.where(name: 'subscriber').first
      end
    end
  end
end