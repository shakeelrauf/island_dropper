class CreateTableUsersRoles < ActiveRecord::Migration[5.1]
  def change
    create_table :users_roles do |t|
      t.integer :user_id
      t.integer :role_id
    end
  end
end
