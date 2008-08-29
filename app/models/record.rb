class Record < ActiveRecord::Base

  acts_as_taggable_on :categories
  acts_as_taggable_on :topics

  before_validation :merge_name_fields

  class << self
    def unused_attributes
      methods = first.attribute_names
      records = all
      unused = methods.collect do |method|
        values = records.collect{|r| r.send(method.to_sym)}
        values.delete_if {|v| v.blank?}.compact
        values.empty? ? method : nil
      end
      unused.compact
    end

    def find_all_by_name_or_notes_like term
      conditions = conditions_by_like(term, :name, :notes)
      find(:all, :conditions => conditions)
    end

    def find_all_by_name_like term
      conditions = conditions_by_like(term, :name)
      records = find(:all, :conditions => conditions).sort_by(&:name)
      records.select {|r| r.name[/(^| |-)#{term}/i] }
    end

    protected
      def conditions_by_like(value, *columns)
        columns = self.column_names if columns.empty?
        conditions = columns.collect {|c|
          "#{c} LIKE " + ActiveRecord::Base.connection.quote("%#{value}%" )
        }
        conditions.join(" OR " )
      end
  end

  def display_title
    "#{title} #{first_name} #{middle_name} #{last_name} #{suffix}".strip
  end

  def line_count
    notes.blank? ? 0 : notes.split("\n").size
  end

  def notes_summary
    notes.blank? ? '' : notes[0..99]
  end

  def core_attribute_names
    %w[notes initial web_page title first_name middle_name last_name suffix id name check_by_date use_check_by_date category]
  end

  def summary_attributes
    summary = attributes
    core_attribute_names.each {|attribute| summary.delete(attribute)}
    summary.delete('updated_at')
    summary.delete('created_at')
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

  protected
    def merge_name_fields
      self.name = "#{title} #{first_name} #{middle_name} #{last_name} #{suffix}".squeeze(' ').strip if respond_to?(:name)
    end
end
