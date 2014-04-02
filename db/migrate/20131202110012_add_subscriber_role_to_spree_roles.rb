class AddSubscriberRoleToSpreeRoles < ActiveRecord::Migration
  def up
    Spree::Role.where(name: "subscriber").first_or_create
    Spree::Subscription.includes(:user).uniq.each do |subscription|
      subscription.add_role_subscriber unless subscription.user.has_spree_role?('subscriber')
    end
  end

  def down
    Spree::Subscription.includes(:user).uniq.each do |subscription|
      subscription.remove_role_subscriber if subscription.user.has_spree_role?('subscriber')
    end
    Spree::Role.where(name: "subscriber").first.try(:destroy)
  end
end
