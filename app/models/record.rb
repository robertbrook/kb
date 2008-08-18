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

  def display_title
    "#{title} #{first_name} #{middle_name} #{last_name} #{suffix}".strip
  end

  def notes_summary
    notes.blank? ? '' : notes[0..99]
  end

  def core_attribute_names
    %w[notes initial web_page title first_name middle_name last_name suffix id]
  end

  def summary_attributes
    summary = attributes
    core_attribute_names.each {|attribute| summary.delete(attribute)}
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

  def html_formatted_notes
    formatted = notes.to_s.strip
    formatted.gsub!(/(http:\/\/\S+)/, '<a href="\1">\1</a>')
    formatted.gsub!("\r\n","\n")
    formatted.gsub!("\n\n","</p><p>")
    formatted.gsub!("\n",'<br />')
    "<p>#{formatted}</p>"
  end
end
