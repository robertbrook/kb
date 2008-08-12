class Record < ActiveRecord::Base

  def note_summary
    note.blank? ? '' : note[0..99]
  end

  def summary_attributes
    summary = attributes
    %w[note initial web_page].each {|attribute| summary.delete(attribute)}
    summary.delete_if {|key,value| value.blank? }
    summary
  end

end
