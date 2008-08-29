class PopulateCategoryTags < ActiveRecord::Migration
  def self.up
    Record.all.each do |record|
      unless record.category.blank?
        category_tags = case record.category
          when "Checked", "checkd", "checked"
            'checked'
          when "DRAFT - IN PROGRESS"
            'draft_in_progress'
          when "Incomplete"
            'incomplete'
          when "Members"
            'members'
          when "Standard Reply", "Standard reply", "standard reply"
            'standard_reply'
          when "standard reply + PQ"
            ['standard_reply','pq']
          when "standard reply/queery"
            ['standard_reply','query']
          when "standard letter"
            'standard_letter'
          when "facts and figures"
            'facts_and_figures'
          when "query"
            'query'
          when "source?"
            'source?'
          when "will need a look at"
            'will_need_a_look_at'
          else
            record.category.downcase.gsub(' ','_')
        end

        category_tags = category_tags.join(', ') if category_tags.is_a?(Array)
        record.category_list = category_tags
        record.save!
      end
    end
  end

  def self.down
    Record.all.each do |record|
      unless record.category.blank?
        record.category_list = nil
        record.save!
      end
    end
  end
end
