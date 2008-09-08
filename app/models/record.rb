class Record < ActiveRecord::Base

  acts_as_taggable_on :tags
  acts_as_taggable_on :statuses

  acts_as_xapian :texts => [ :name, :notes, :other_notes ],
       :values => [ [ :created_at, 0, "created_at", :date ] ],
       :terms => []

  class << self

    def search term
      search = ActsAsXapian::Search.new(Record, term, :limit => 200)
      if search.results.empty?
        return [[], [], search.spelling_correction]
      else
        return [search.results.collect{|h| h[:model]}, search.words_to_highlight, nil]
      end
    end

    def all_needing_check
      past_check_by_date = { :conditions => 'use_check_by_date = "t" AND check_by_date <= date("now")' }
      find(:all, past_check_by_date)
    end

    def common_tags
      topics = Record.tag_counts.select {|t| t.taggings.size > 1}
      topics.collect(&:name).sort
    end

    def common_statuses
      Record.status_counts.collect(&:name).sort
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

  def line_count
    notes.blank? ? 0 : notes.split("\n").size
  end

  def notes_summary
    if summary.blank?
      notes.blank? ? '' : "#{notes[0..99]}..."
    else
      summary
    end
  end

  def <=> other_record
    name <=> other_record.name
  end

end
