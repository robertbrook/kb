class PopulateRecords < ActiveRecord::Migration
  def self.up
    file = File.dirname(__FILE__) + '/../../data/kbfile.csv'
    FasterCSV.foreach(file, :headers => :first_row) do |column_values|

      attributes = Hash.new

      column_values.each do |column_value|
        attribute = convert_to_attribute(column_value[0])
        value = clean_value(attribute, column_value[1])
        attributes[attribute] = value
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

  def self.clean_value attribute, value
    if [:gender, :private, :priority, :sensitivity].include?(attribute) || value == '0/0/00'
      nil
    else
      value
    end
  end

  def self.convert_to_attribute column
    column.to_s.tableize.tr(' ','_').tr("'",'').tr('/','').singularize.sub('faxis','fax').sub(/^callback/,'callback_attribute').to_sym
  end

  def self.down
    Record.delete_all
  end
end
