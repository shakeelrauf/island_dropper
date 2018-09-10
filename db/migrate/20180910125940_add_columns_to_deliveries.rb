class AddColumnsToDeliveries < ActiveRecord::Migration[5.1]
  def change
    add_column :deliveries , :priority , :boolean, default: false
    add_column :deliveries , :pre_order , :boolean, default: false
    remove_column :deliveries , :make_priority_or_preorder, :string
  end
end
