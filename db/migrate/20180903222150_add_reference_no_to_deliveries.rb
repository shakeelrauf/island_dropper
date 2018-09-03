class AddReferenceNoToDeliveries < ActiveRecord::Migration[5.1]
  def change
    add_column :deliveries, :reference_no, :string
  end
end
