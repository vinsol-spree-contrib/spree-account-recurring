module Spree
  class SubscriptionPlan < Spree::Base
    include RestrictiveDestroyer
    include ApiHandler

    acts_as_restrictive_destroyer column: :unsubscribed_at
    attr_accessor :card_token

    self.whitelisted_ransackable_attributes = %w[email subscribed_at]

    belongs_to :plan
    belongs_to :user
    has_many :events, class_name: 'Spree::SubscriptionEvent'

    validates :plan_id, :email, :user_id, presence: true
    validates :plan_id, uniqueness: { scope: [:user_id, :unsubscribed_at] }
    validates :user_id, uniqueness: { scope: :unsubscribed_at }

    if Rails.version.to_f >= 5.1
      delegate :api_plan_id, to: :plan
    else
      delegate_belongs_to :plan, :api_plan_id
    end

    before_validation :set_email, on: :create

    validate :verify_plan, on: :create

    scope :active, -> { where(unsubscribed_at: nil) }

    private

    def set_email
      self.email = user.try(:email)
    end

    def verify_plan
      errors.add :plan_id, "is not active." unless plan.try(:visible?)
    end
  end
end