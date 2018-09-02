class CreatePickups < ActiveRecord::Migration[5.1]
  def change
    create_table :pickups do |t|
      t.string :first_name
      t.string :last_name
      t.string :address
      t.string :phone_number
      t.integer :delivery_id

      t.timestamps
    end
  end
end
