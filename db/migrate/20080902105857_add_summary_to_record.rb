class AddSummaryToRecord < ActiveRecord::Migration
  def self.up
    add_column :records, :summary, :string
  end

  def self.down
    remove_column :records, :summary
  end
end
