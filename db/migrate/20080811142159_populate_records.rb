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
        record = create_record attributes
        record.save! unless is_letter_index? record
      rescue Exception => e
        puts attributes.inspect
        raise e
      end
    end
  end

  def self.create_record attributes
    record = Record.new(attributes)
    move_last_name(record) if only_last_name_populated? record
    move_middle_and_last_name(record) if only_last_and_middle_name_populated? record
    record
  end

  def self.only_last_name_populated? record
    record.first_name.blank? && record.middle_name.blank? && !record.last_name.blank?
  end

  def self.only_last_and_middle_name_populated? record
    record.first_name.blank? && !record.middle_name.blank? && !record.last_name.blank?
  end

  def self.move_last_name record
    record.first_name = record.last_name
    record.last_name = ''
  end

  def self.move_middle_and_last_name record
    record.first_name = record.middle_name
    record.middle_name = record.last_name
    record.last_name = ''
  end

  def self.is_letter_index? record
    (record.first_name.blank? || record.first_name.to_s.size == 1) && record.note.blank?
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
