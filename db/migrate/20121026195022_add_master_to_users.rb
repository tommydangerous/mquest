class AddMasterToUsers < ActiveRecord::Migration
  def change
    add_column :users, :master, :boolean, default: false
    add_index :users, :master
  end
end
