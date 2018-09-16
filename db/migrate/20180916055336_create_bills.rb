class CreateBills < ActiveRecord::Migration[5.1]
  def change
    create_table :bills do |t|
      t.string :amount
      t.string :stripe_transaction_id
      t.integer :dropoff_id

      t.timestamps
    end
  end
end
