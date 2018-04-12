class AddDefaultToSpreePlans < ActiveRecord::Migration[4.2]
  def change
    add_column :spree_plans, :default, :boolean, default: false
    add_index :spree_plans, :default
  end
end
