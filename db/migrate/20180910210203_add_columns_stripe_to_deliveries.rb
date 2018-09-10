class AddColumnsStripeToDeliveries < ActiveRecord::Migration[5.1]
  def change
    add_column :deliveries, :stripe_transaction_id, :string
  end
end
