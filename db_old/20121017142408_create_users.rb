class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :encrypted_password
      t.string :salt
      t.boolean :admin
      t.string :slug
      t.datetime :last_in
      t.integer :in_count

      t.timestamps
    end
    add_index :users, :name, unique: true
    add_index :users, :email
    add_index :users, :admin
    add_index :users, :slug
    add_index :users, :last_in
    add_index :users, :in_count
  end
end
