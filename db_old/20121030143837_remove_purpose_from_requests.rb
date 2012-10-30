class RemovePurposeFromRequests < ActiveRecord::Migration
	def change
		remove_index :request_purposes, [:request_id, :purpose_id]
		drop_table :request_purposes
		remove_index :requests, :purpose
		remove_column :requests, :purpose
	end
end
