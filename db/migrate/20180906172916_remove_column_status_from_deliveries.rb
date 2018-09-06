class RemoveColumnStatusFromDeliveries < ActiveRecord::Migration[5.1]
  def change
    remove_column :deliveries, :status, :string
  end
end
