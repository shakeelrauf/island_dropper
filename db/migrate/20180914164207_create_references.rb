class CreateReferences < ActiveRecord::Migration[5.1]
  def up
    create_table :references do |t|
      t.string :reference_no
      t.integer :delivery_id

      t.timestamps
    end
    Delivery.all.each do |d|
      if !d.reference_no.nil?
        eval(d.reference_no).each do |e|
          if !e.nil?
            d.references.build(reference_no: e ) 
            d.save
          end
        end
      end
    end
  end

  def down
    drop_table :references
  end
end
