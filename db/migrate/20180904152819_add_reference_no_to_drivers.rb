class AddReferenceNoToDrivers < ActiveRecord::Migration[5.1]
  def change
    add_column :drivers, :reference_no, :string
  end
end
