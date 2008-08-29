class AddCheckByDateToRecords < ActiveRecord::Migration
  def self.up
    add_column :records, :check_by_date, :date
    add_column :records, :use_check_by_date, :boolean
  end

  def self.down
    remove_column :records, :check_by_date, :date
    remove_column :records, :use_check_by_date, :date
  end
end
