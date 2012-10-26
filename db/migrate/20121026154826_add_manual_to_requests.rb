class AddManualToRequests < ActiveRecord::Migration
  def change
    add_column :requests, :manual, :boolean, default: false
    add_index :requests, :manual
  end
end
