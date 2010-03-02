class AddNameToRecords < ActiveRecord::Migration
  def self.up
    add_column :records, :name, :string

    # Record.reset_column_information
    # 
    # Record.all.each do |r|
    #   r.name = "#{r.title} #{r.first_name} #{r.middle_name} #{r.last_name} #{r.suffix}".squeeze(' ').strip
    #   r.save!
    # end
  end

  def self.down
    remove_column :records, :name
  end
end
