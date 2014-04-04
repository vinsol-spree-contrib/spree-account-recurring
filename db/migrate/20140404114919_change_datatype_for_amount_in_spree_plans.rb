class ChangeDatatypeForAmountInSpreePlans < ActiveRecord::Migration
  def up
    change_column :spree_plans, :amount, :decimal, :scale => 2, :precision => 8
  end

  def down
    change_column :spree_plans, :amount, :integer
  end
end
