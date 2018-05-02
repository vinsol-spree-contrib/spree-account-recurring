class AddPreferenceToSpreeRecurring < ActiveRecord::Migration[4.2]
  def change
    add_column :spree_recurrings, :preferences, :text
  end
end
