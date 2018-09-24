class AddTokenColumnToDeliveries < ActiveRecord::Migration[5.1]
  def change
    add_column :deliveries, :token, :string
    Delivery.all.each do |d|
    	d.generate_token
    	d.save
    end
  end
end
