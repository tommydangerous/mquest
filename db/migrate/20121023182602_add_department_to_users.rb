class AddDepartmentToUsers < ActiveRecord::Migration
  def change
    add_column :users, :department, :string
    add_index :users, :department
  end
end
