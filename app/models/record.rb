require 'ostruct'

class Record < ActiveRecord::Base

  has_friendly_id :name, :use_slug => true
  # has_friendly_id :name, :use_slug => true, :strip_diacritics => true

  acts_as_taggable_on :tags
  acts_as_taggable_on :statuses

  acts_as_xapian :texts => [ :name, :notes, :other_notes ],
       :values => [ [ :created_at, 0, "created_at", :date ] ],
       :terms => []

  class << self

    def find_with_tag tag
      tags = Record.find_tagged_with(tag, :on=>'tags')
      tags.sort_by(&:name)
    end

    def find_with_status status
      statuses = Record.find_tagged_with(status, :on=>'statuses')
      statuses.sort_by(&:name)
    end

    def tag_query_results query, tag
      search = ActsAsXapian::Search.new(Record, query, :limit => 1, :offset => 0)
      if search.results.empty?
        []
      else
        matches_estimated = search.matches_estimated
        search = ActsAsXapian::Search.new(Record, query, :limit => matches_estimated+1, :offset => 0)
        records = search.results.collect{|h| h[:model]}
        add_tag tag, records.collect(&:id)
      end
    end

    def add_tag tag, record_ids
      records = record_ids.collect{|id| Record.find(id)}

      records.each do |record|
        record.add_tag tag
        record.save
      end
      records
    end

    def rename_tag old_tag, new_tag
      records = find_with_tag old_tag
      records.each do |record|
        record.rename_tag old_tag, new_tag
        record.save
      end
      records
    end

    def delete_tag tag
      records = find_with_tag tag
      records.each do |record|
        record.remove_tag tag
        record.save
      end
      records
    end

    def per_page
      10
    end

    def search term, offset
      search = ActsAsXapian::Search.new(Record, term, :limit => per_page, :offset => offset)
      matches_estimated = search.matches_estimated

      if search.results.empty?
        return [[], [], matches_estimated, search.spelling_correction]
      else
        return [search.results.collect{|h| h[:model]}, search.words_to_highlight, matches_estimated, nil]
      end
    end

    def all_needing_check
      past_check_by_date = { :conditions => 'use_check_by_date = "t" AND check_by_date <= date("now")' }
      find(:all, past_check_by_date)
    end

    def recently_edited
      find(:all, :limit => 5, :order => 'updated_at desc')
    end

    def common_tags
      tags = Record.tag_counts.select {|t| t.taggings.size > 2}
      tags.sort_by(&:name)
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

  def rename_tag old_tag, new_tag
    remove_tag old_tag
    add_tag new_tag
  end

  def add_tag tag
    tag_list.add tag
  end

  def remove_tag tag
    tag_list.remove tag
  end

  def similar_records
    results = ActsAsXapian::Similar.new([Record], [self], :limit=>10).results.collect{|r| OpenStruct.new r}
    results = results.select{|r| r.percent > 29 }
    results
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
