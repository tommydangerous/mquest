class AddManualByToRequests < ActiveRecord::Migration
  def change
    add_column :requests, :manual_by, :integer
    add_index :requests, :manual_by
  end
end
