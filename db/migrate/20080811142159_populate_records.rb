class PopulateRecords < ActiveRecord::Migration
  def self.up
    file = File.dirname(__FILE__) + '/../../data/kbfile.csv'
    FasterCSV.foreach(file, :headers => :first_row) do |column_values|

      attributes = Hash.new

      column_values.each do |column_value|
        column_name, value = column_value[0], column_value[1]
        attributes[key(column_name)] = value
      end

      begin
        record = Record.new(attributes)
        record.save!
      rescue Exception => e
        puts attributes.inspect
        raise e
      end
    end
  end

  def self.key column
    column.to_s.tableize.tr(' ','_').tr("'",'').tr('/','').singularize.sub('faxis','fax').sub(/^callback/,'callback_attribute').to_sym
  end

  def self.down
    Record.delete_all
  end
end
