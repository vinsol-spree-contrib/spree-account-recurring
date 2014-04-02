module RestrictiveDestroyer
  extend ActiveSupport::Concern

  included do
    before_destroy :destroyable?
  end

  module ClassMethods
    def acts_as_restrictive_destroyer(options={})
      raise ArgumentError, "Hash expected, got #{options.class.name}" unless options.is_a?(Hash)
      class_attribute :restrictive_destroyer_config, :restrictive_destroyer_col_ref
      self.restrictive_destroyer_config = { column: "deleted_at" }.merge!(options)
      self.restrictive_destroyer_col_ref = "#{self.table_name}.#{restrictive_destroyer_config[:column]}"
      scope :undeleted, -> { where("#{restrictive_destroyer_col_ref} IS NULL") }
      scope :deleted, -> { where("#{restrictive_destroyer_col_ref} IS NOT NULL") }
    end
  end
  
  def readonly?
    is_destroyed?
  end

  def restrictive_destroy
    update_attributes("#{restrictive_destroyer_attr_ref}" => Time.current)
  end

  def restrictive_destroy_with_api
    save_and_manage_api("#{restrictive_destroyer_attr_ref}" => Time.current)
  end

  def is_destroyed?
    !send("#{restrictive_destroyer_attr_ref}_changed?") && send("#{restrictive_destroyer_attr_ref}?")
  end

  private

  def restrictive_destroyer_attr_ref
    self.class.restrictive_destroyer_config[:column]
  end

  def destroyable?
    false
  end
end