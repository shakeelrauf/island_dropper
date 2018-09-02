class AddColumsToDeliveries < ActiveRecord::Migration[5.1]
  def change
    add_column :deliveries, :make_priority_order, :boolean,default: false 
    add_column :deliveries, :pre_order, :boolean,default: false 
    add_column :deliveries, :pre_order_date, :date
  end
end
