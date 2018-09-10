class CreateItemTypes < ActiveRecord::Migration[5.1]
  def change
    create_table :item_types do |t|
      t.string :title
      t.string :base_rate
      t.string :per_km_rate

      t.timestamps
    end
  end
end
