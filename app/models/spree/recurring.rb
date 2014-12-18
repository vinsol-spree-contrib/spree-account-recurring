module Spree
  class Recurring < Spree::Base
    include RestrictiveDestroyer

    acts_as_restrictive_destroyer

    preference :secret_key, :string
    preference :public_key, :string

    has_many :plans
    attr_readonly :type
    validates :type, :name, presence: true
    validates :type, uniqueness: { message: 'of provider recurring already exists' }

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
  end
end