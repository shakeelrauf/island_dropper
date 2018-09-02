class AddStateToDeliveries < ActiveRecord::Migration[5.1]
  def change
    add_column :deliveries, :state, :string, default: 'new'
  end
end
