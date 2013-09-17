class CreateHalfDays < ActiveRecord::Migration
  def change
    create_table :half_days do |t|
      t.string :name

      t.timestamps
    end

    add_index :half_days, :name, unique: true
  end
end
