class CreateSecrets < ActiveRecord::Migration
  def change
    create_table :secrets do |t|
      t.string :name
      t.string :code

      t.timestamps
    end
    add_index :secrets, :name, unique: true
    add_index :secrets, :code
  end
end
