class CreateSpreeRecurring < ActiveRecord::Migration
  def change
    create_table :spree_recurrings do |t|
      t.string :name
      t.string :type
      t.text :description
      t.boolean :active
      t.datetime :deleted_at
    end

    add_index :spree_recurrings, :deleted_at
  end
end
