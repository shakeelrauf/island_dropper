class AddStatusAndReferenceNoToDropoffs < ActiveRecord::Migration[5.1]
  
  def up
    add_column :dropoffs, :state, :string
    add_column :dropoffs, :reference_no, :string
    add_column :dropoffs, :tracking_url, :string
    add_column :drivers, :dropoff_id, :integer
    drop_table :references
    Delivery.all.each do |d|
      d.dropoffs.each.with_index do |dd,i|
        if !d.reference_no.nil?
          dd.reference_no = eval(d.reference_no)[i]
          dd.state = d.state
          dd.save     
        end  
      end
    end

  end

  def down
    remove_column :dropoffs, :state, :string
    remove_column :drivers, :dropoff_id, :integer
    remove_column :dropoffs, :reference_no, :string
    remove_column :dropoffs, :tracking_url, :string
    create_table :references do |t|
      t.string :reference_no
      t.integer :delivery_id

      t.timestamps
    end
  end
end
