class CreateItems < ActiveRecord::Migration[5.1]
  def change
    create_table :items do |t|
      t.string :size, default: "small"
      t.string :description
      t.references :delivery, foreign_key: true

      t.timestamps
    end
  end
end
