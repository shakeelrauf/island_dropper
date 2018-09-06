class AddColumnsToDrivers < ActiveRecord::Migration[5.1]
  def change
    add_column :drivers, :email, :string
    add_column :drivers, :photo_url, :string
  end
end
