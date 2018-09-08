class AddLatLngToPickupDropoffs < ActiveRecord::Migration[5.1]
  def change
    add_column :dropoffs, :latitude, :string
    add_column :dropoffs, :longitude, :string
    add_column :pickups, :latitude, :string
    add_column :pickups, :longitude, :string
  end
end
