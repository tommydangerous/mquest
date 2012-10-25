class RemoveUserIdFromDepartments < ActiveRecord::Migration
  def change
  	remove_index :departments, :user_id
  	remove_column :departments, :user_id
  end
end
