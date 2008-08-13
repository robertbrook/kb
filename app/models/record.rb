class Record < ActiveRecord::Base

  class << self
    def unused_attributes
      methods = first.attributes.keys.sort
      records = all
      methods.collect do |method|
        values = records.collect{|r| r.send(method.to_sym)}
        values.delete_if {|v| v.blank?}.compact
        values.empty? ? method : nil
      end.compact
    end
  end

  def note_summary
    note.blank? ? '' : note[0..99]
  end

  def summary_attributes
    summary = attributes
    %w[note initial web_page title first_name middle_name last_name suffix id].each {|attribute| summary.delete(attribute)}
    summary.delete_if {|key,value| value.blank? }
    summary
  end

  def <=> other_record
    comparison = first_name <=> other_record.first_name
    if comparison != 0
      comparison
    else
      comparison = middle_name <=> other_record.middle_name
      if comparison != 0
        comparison
      else
        last_name <=> other_record.last_name
      end
    end
  end

end
