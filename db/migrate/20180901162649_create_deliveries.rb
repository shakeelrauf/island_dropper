class CreateDeliveries < ActiveRecord::Migration[5.1]
  def change
    create_table :deliveries do |t|
      t.string :b_id
      t.string :status
      t.string :pickup_location
      t.string :dropout_location
      t.integer :fee
      t.text :response

      t.timestamps
    end
  end
end
