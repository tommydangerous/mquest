class CreateRequestPurposes < ActiveRecord::Migration
  def change
    create_table :request_purposes do |t|
      t.integer :request_id
      t.integer :purpose_id

      t.timestamps
    end
    add_index :request_purposes, [:request_id, :purpose_id], unique: true
  end
end
