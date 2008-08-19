class AddNameToRecords < ActiveRecord::Migration
  def self.up
    add_column :records, :name, :string

    Record.reset_column_information

    Record.all.each {|r| r.save!}
  end

  def self.down
    remove_column :records, :name
  end
end
