class AddColumnToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :reset_password_token_created, :boolean, default: false
  end
end
