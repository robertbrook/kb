class PopulateTopicTags < ActiveRecord::Migration
  def self.up
    Record.all.each do |record|
      topics = []
      [:title, :first_name, :middle_name, :last_name, :suffix].each do |topic_attribute|
        topic = record.send(topic_attribute)
        unless topic.blank?
          topic = topic.strip.downcase.gsub(' ','_').gsub(/[^a-z^_^-]/,'').squeeze('_').chomp('_')[/^_?(.+)$/,1]
          unless topic.blank?
            topics << topic
          end
        end
      end
      record.topic_list = topics.join(', ')
      record.save!
      puts record.topic_list.inspect
    end
  end

  def self.down
    Record.all.each do |record|
      record.topic_list = nil
      record.save!
    end
  end
end
