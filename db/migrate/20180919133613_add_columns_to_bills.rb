class AddColumnsToBills < ActiveRecord::Migration[5.1]
  def change
    add_column :bills, :response, :text
  end
end
