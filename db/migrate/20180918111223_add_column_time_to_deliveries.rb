class AddColumnTimeToDeliveries < ActiveRecord::Migration[5.1]
  def up
    change_column :deliveries, :pre_order_date, :datetime
    add_column :deliveries, :processed, :boolean, default: :false
  end
  def down
    change_column :deliveries, :pre_order_date, :date
    remove_column :deliveries, :processed, :boolean, default: :false
  end
end
