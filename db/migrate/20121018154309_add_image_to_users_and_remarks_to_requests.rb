class AddImageToUsersAndRemarksToRequests < ActiveRecord::Migration
  def change
  	add_column :users, :image, :string
  	add_column :requests, :remarks, :text
  	change_column :users, :admin, :boolean, default: false
  	add_index :users, :image
  	add_index :requests, :remarks
  end
end