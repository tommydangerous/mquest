class CreateDecisions < ActiveRecord::Migration
  def change
    create_table :decisions do |t|
      t.string :name
      t.integer :request_id
      t.integer :user_id

      t.timestamps
    end
    add_index :decisions, :name
    add_index :decisions, :request_id
    add_index :decisions, :user_id
  end
end
