class AddTrackingUrlToDeliveries < ActiveRecord::Migration[5.1]
  def change
    add_column :deliveries, :tracking_url, :string
    add_column :drivers, :phone_number, :string
  end
end
