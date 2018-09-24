class AddUserIdToDropoffs < ActiveRecord::Migration[5.1]
  def change
    add_column :dropoffs, :user_id, :integer
   	Delivery.all.each do |d|
   		d.dropoffs.each do |e|
   			e.user_id = d.user_id
   			e.save
   		end
   	end
  end
end
