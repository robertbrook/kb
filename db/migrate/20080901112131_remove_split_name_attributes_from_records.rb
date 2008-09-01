class RemoveSplitNameAttributesFromRecords < ActiveRecord::Migration
  def self.up
    remove_column :records, :title
    remove_column :records, :first_name
    remove_column :records, :middle_name
    remove_column :records, :last_name
    remove_column :records, :suffix
  end

  def self.down
    add_column :records, :title
    add_column :records, :first_name
    add_column :records, :middle_name
    add_column :records, :last_name
    add_column :records, :suffix
  end
end
