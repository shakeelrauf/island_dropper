class RemoveColumnFromDeliveries < ActiveRecord::Migration[5.1]
  def change
    remove_column :deliveries,:dropout_location,:string
    remove_column :deliveries,:fee, :float
    remove_column :deliveries,:pickup_location, :string
  end
end
