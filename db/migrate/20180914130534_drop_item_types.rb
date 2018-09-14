class DropItemTypes < ActiveRecord::Migration[5.1]
  def up
    drop_table :item_types
    drop_table  :priorities
  end

  def down
    create_table :item_types do |t|
      t.string :title
      t.string :base_rate
      t.string :per_km_rate

      t.timestamps
    end
     create_table :priorities do |t|
      t.float :percentage

      t.timestamps
    end
  end
end
