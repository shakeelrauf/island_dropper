class CreateDropoffs < ActiveRecord::Migration[5.1]
  def change
    create_table :dropoffs do |t|
      t.string :first_name
      t.string :last_name
      t.string :address
      t.string :phone_number
      t.text :delivery_instructions
      t.references :delivery, foreign_key: true

      t.timestamps
    end
  end
end
