class AddMakePriorityOrPreorderToDeliveries < ActiveRecord::Migration[5.1]
  def change
    add_column :deliveries, :make_priority_or_preorder, :string
    remove_column :deliveries, :make_priority_order, :boolean,default: false 
    remove_column :deliveries, :pre_order, :boolean,default: false 
  end
end
