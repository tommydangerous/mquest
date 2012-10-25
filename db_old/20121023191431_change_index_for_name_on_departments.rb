class ChangeIndexForNameOnDepartments < ActiveRecord::Migration
  def change
  	remove_index :departments, :name
  	add_index :departments, :name, unique: true
  end
end
