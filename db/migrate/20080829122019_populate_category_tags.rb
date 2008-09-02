class PopulateCategoryTags < ActiveRecord::Migration
  def self.up
    Record.all.each do |record|
      unless record.category.blank?
        statuses = case record.category
          when "Checked", "checkd", "checked"
            'checked'
          when "DRAFT - IN PROGRESS"
            'draft in progress'
          when "Incomplete"
            'incomplete'
          when "Members"
            'members'
          when "Standard Reply", "Standard reply", "standard reply"
            'standard reply'
          when "standard reply + PQ"
            ['standard reply','pq']
          when "standard reply/queery"
            ['standard reply','query']
          when "standard letter"
            'standard letter'
          when "facts and figures"
            'facts and figures'
          when "query"
            'query'
          when "source?"
            'source?'
          when "will need a look at"
            'will need a look at'
          else
            record.category.downcase
        end

        statuses = statuses.join(', ') if statuses.is_a?(Array)
        record.status_list = statuses
        record.save!
      end
    end
  end

  def self.down
    Record.all.each do |record|
      unless record.category.blank?
        record.status_list = nil
        record.save!
      end
    end
  end
end
