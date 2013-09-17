class AddColumnHalfDayToRequests < ActiveRecord::Migration
  def change
    add_column :requests, :half_day, :boolean, default: false

    add_index :requests, :half_day
  end
end
