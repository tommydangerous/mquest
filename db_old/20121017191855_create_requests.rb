class CreateRequests < ActiveRecord::Migration
  def change
    create_table :requests do |t|
      t.integer :user_id
      t.datetime :request_start
      t.datetime :request_end
      t.integer :total_days
      t.integer :total_hours
      t.string :purpose
      t.text :comments
      t.boolean :scheduled
      t.boolean :called_in
      t.boolean :absence_paid

      t.timestamps
    end
    add_index :requests, :user_id
    add_index :requests, :request_start
    add_index :requests, :request_end
    add_index :requests, :total_days
    add_index :requests, :total_hours
    add_index :requests, :purpose
    add_index :requests, :comments
    add_index :requests, :scheduled
    add_index :requests, :called_in
    add_index :requests, :absence_paid
  end
end
