class CreateDrivers < ActiveRecord::Migration[5.1]
  def change
    create_table :drivers do |t|
      t.string :driver_name
      t.string :driver_location
      t.integer :delivery_id

      t.timestamps
    end
  end
end
