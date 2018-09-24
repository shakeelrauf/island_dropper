class RenameColumnsOfPricing < ActiveRecord::Migration[5.1]
  def self.up
  	rename_column :pricings, :van_small_price, :van_large_price
  	rename_column :pricings, :car_large_price, :car_small_price
  end
  def self.down
  	rename_column :pricings, :van_large_price, :van_small_price
  	rename_column :pricings, :car_small_price, :car_large_price
  end
end
