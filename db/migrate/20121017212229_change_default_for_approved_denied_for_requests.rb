class ChangeDefaultForApprovedDeniedForRequests < ActiveRecord::Migration
	def change
		change_column :requests, :approved, :boolean, default: false
		change_column :requests, :denied, :boolean, default: false
	end
end