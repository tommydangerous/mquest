class AddMaxOffToHalfDays < ActiveRecord::Migration
  def change
    add_column :half_days, :max_off, :integer
  end
end
