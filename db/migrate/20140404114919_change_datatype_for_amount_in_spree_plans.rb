class ChangeDatatypeForAmountInSpreePlans < ActiveRecord::Migration
  def up
    change_column :spree_plans, :amount, :decimal
  end

  def down
    change_column :spree_plans, :amount, :integer
  end
end
