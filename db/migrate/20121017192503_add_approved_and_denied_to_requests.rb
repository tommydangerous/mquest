class AddApprovedAndDeniedToRequests < ActiveRecord::Migration
  def change
    add_column :requests, :approved, :boolean
    add_column :requests, :denied, :boolean
    add_index :requests, :approved
    add_index :requests, :denied
  end
end
