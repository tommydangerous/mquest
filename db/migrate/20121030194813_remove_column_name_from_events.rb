class RemoveColumnNameFromEvents < ActiveRecord::Migration
  def change
  	remove_index :events, :name
  	add_column :events, :purpose_id, :integer
  	add_index :events, :purpose_id
  end
end
