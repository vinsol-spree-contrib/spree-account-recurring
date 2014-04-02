module Spree
  class SubscriberAbility
    include CanCan::Ability

    def initialize(user)
      # if user.respond_to?(:has_spree_role?) && user.has_spree_role?('subscriber')
      #   can :create, Order
      #   can :update, Order do |order, token|
      #     order.user == user || order.token && token == order.token
      #   end
      # else
      #   cannot :create, Order
      #   cannot :update, Order
      # end
    end
  end
end