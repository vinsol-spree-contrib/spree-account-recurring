module Spree
  class Plan < Spree::Base
    include RestrictiveDestroyer
    include ApiHandler

    acts_as_restrictive_destroyer

    belongs_to :recurring
    has_many :subscription_plans

    validates :amount, :interval, :interval_count, :name, :currency, :recurring_id, :api_plan_id, presence: true
    attr_readonly :amount, :interval, :currency, :id, :trial_period_days, :interval_count, :recurring_id, :api_plan_id

    before_validation :manage_default, if: :default_changed?
    before_update :ensure_no_active_subscription, if: :deleted_at_changed?

    scope :active, -> { undeleted.where(active: true) }
    scope :visible, -> { active.joins(:recurring).where(["spree_recurrings.active = ? AND spree_recurrings.deleted_at IS NULL", true]) }

    def visible?
      active? && !is_destroyed? && recurring.visible?
    end

    def manage_default
      recurring.plans.undeleted.where.not(id: id).update_all(default: false)
    end

    def self.default
      visible.find_by(default: true)
    end

    private

      def ensure_no_active_subscription
        if subscription_plans.active.present?
          errors.add(:base, "You can not delete a plan with active subscriptions")
          false
        end
      end
  end
end