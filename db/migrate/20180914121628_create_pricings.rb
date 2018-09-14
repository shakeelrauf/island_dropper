class CreatePricings < ActiveRecord::Migration[5.1]
  def change
    create_table :pricings do |t|
      t.float :van_small_price
      t.float :car_medium_price
      t.float :car_large_price
      t.float :van_furniture_price
      t.float :car_base_price
      t.float :van_base_price
      t.float :priority_percentage

      t.timestamps
    end
  end
end
