class AddApprovedByAndDeniedByToRequests < ActiveRecord::Migration
  def change
    add_column :requests, :approved_by, :integer
    add_column :requests, :denied_by, :integer
    add_index :requests, :approved_by
    add_index :requests, :denied_by
  end
end
