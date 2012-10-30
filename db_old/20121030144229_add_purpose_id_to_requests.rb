class AddPurposeIdToRequests < ActiveRecord::Migration
  def change
    add_column :requests, :purpose_id, :integer
    add_index :requests, :purpose_id
  end
end
