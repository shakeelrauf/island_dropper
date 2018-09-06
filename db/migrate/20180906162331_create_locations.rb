class CreateLocations < ActiveRecord::Migration[5.1]
  def change
    create_table :locations do |t|
      t.string :longitude
      t.string :latitude
      t.integer :delivery_id
      t.string :when_state

      t.timestamps
    end
  end
end
