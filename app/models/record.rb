class Record < ActiveRecord::Base

  def note_summary
    note.blank? ? '' : note[0..99]
  end

  def summary_attributes
    non_blank = attributes
    non_blank.delete('note')
    non_blank.delete('initial')
    non_blank.delete_if {|key,value| value.blank? }
    non_blank
  end

end
