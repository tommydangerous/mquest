class CreateDepartments < ActiveRecord::Migration
  def change
    create_table :departments do |t|
      t.string :name
      t.integer :user_id
      t.integer :max_off

      t.timestamps
    end
    add_index :departments, :name
    add_index :departments, :user_id
    add_index :departments, :max_off
  end
end
