module Spree
  class Recurring < Spree::Base
    include RestrictiveDestroyer

    acts_as_restrictive_destroyer

    preference :secret_key, :string
    preference :public_key, :string

    has_many :plans
    attr_readonly :type
    validates :type, :name, presence: true
    validates :type, uniqueness: { message: 'of provider recurring already exists', scope: :deleted_at }

    before_update :ensure_no_undeleted_plans_present, if: :deleted_at_changed?

    scope :active, -> { undeleted.where(active: true) }

    def self.display_name
      name.gsub(%r{.+:}, '')
    end

    def visible?
      active? && !is_destroyed?
    end

    def default_plan
      plans.default
    end

    def has_preferred_keys?
      preferred_secret_key.present? && preferred_public_key.present?
    end

    private

      def ensure_no_undeleted_plans_present
        if plans.undeleted.present?
          errors.add(:base, "You can not delete a recurring with active plans")
          false
        end
      end
  end
end