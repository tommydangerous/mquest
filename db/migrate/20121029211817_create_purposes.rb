class CreatePurposes < ActiveRecord::Migration
  def change
    create_table :purposes do |t|
      t.string :name

      t.timestamps
    end
    add_index :purposes, :name, unique: true
  end
end
