class AddRequestIdToEvents < ActiveRecord::Migration
  def change
    add_column :events, :request_id, :integer
    add_index :events, :request_id
  end
end
