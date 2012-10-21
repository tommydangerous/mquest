class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name
      t.datetime :event_date
      t.datetime :date_requested
      t.integer :user_id
      t.integer :approved_by

      t.timestamps
    end
    add_index :events, :name
    add_index :events, :event_date
    add_index :events, :date_requested
    add_index :events, :user_id
    add_index :events, :approved_by
  end
end
