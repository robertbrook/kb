class AddExpiryDateToRecords < ActiveRecord::Migration
  def self.up
    add_column :records, :expiry_date, :date
    add_column :records, :use_expiry_date, :boolean
  end

  def self.down
    remove_column :records, :expiry_date, :date
    remove_column :records, :use_expiry_date, :date
  end
end
