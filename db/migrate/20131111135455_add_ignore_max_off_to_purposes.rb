class AddIgnoreMaxOffToPurposes < ActiveRecord::Migration
  def change
    add_column :purposes, :ignore_max_off, :boolean, default: false

    add_index :purposes, :ignore_max_off
  end
end
