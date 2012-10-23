class RemoveColumnDepartmentOnUsers < ActiveRecord::Migration
  def change
  	remove_index :users, :department
  	remove_column :users, :department
  end
end
