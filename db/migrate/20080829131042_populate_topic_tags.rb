class PopulateTopicTags < ActiveRecord::Migration
  def self.up
    Record.all.each do |record|
      topics = []
      [:title, :first_name, :middle_name, :last_name, :suffix].each do |topic_attribute|
        topic = record.send(topic_attribute)
        unless topic.blank?
          topic = topic.strip.downcase.strip.gsub(/:^$/,', ').gsub('/',', ').gsub(/[^a-z^-^ ^,]/,'').squeeze(' ').strip
          unless topic.blank? || topic == '-'
            topics << topic
          end
        end
      end
      topics = topics.join(', ')

      topics.sub!('select, committees,', 'select committees, committees,')
      topics.sub!('select, committees ', 'select committees, committees, ')
      topics.sub!(' - in,',',')
      topics.sub!('bill committee', 'committee, bill committee')
      topics.sub!('constituents ', 'constituents, ')
      topics.sub!('commission ', 'commission, ')
      topics.sub!('committee ', 'committee, ')
      topics.sub!('reading committee', 'committee, reading committee')
      topics.sub!('committees definition','committees, definition')
      topics.sub!('standing committees','committees, standing committees')
      topics.sub!('statues members','statues, members')
      topics.sub!('meps access to','meps, access to')
      topics.sub!('senior salaries review body ssrb','salaries, review body, ssrb')
      topics.sub!('senior salaries review body ssrb','salaries, review body, ssrb')
      topics.sub!('queens speech amendment on the', 'queens speech, amendment on the')
      topics.sub!('mps returned for two','mps, returned for two')
      topics.sub!('seats won by country', 'seats, won by country')
      topics.sub!('private members bills','bills, members, private members bills')
      topics.sub!('constituencies ','constituencies, ')
      topics.sub!('bills time spent', 'bills, time spent')
      topics.sub!('history of parliament','history, parliament')
      topics.sub!('orders and regulations','orders, regulations')
      topics.sub!('visiting each others','visiting')
      topics.sub!('govt', 'government')
      topics.sub!('defeats ', 'defeats, ')
      topics.sub!('to contact ministersgovernment','contact, ministers, government')
      topics.sub!('depts','departments')
      topics.sub!(' grand, committee', ', grand committee, committee')
      topics.sub!('ii house of commons evacuation','house of commons, evacuation')
      topics.sub!('ii end europe','europe')
      topics.sub!('rt hon sir','rt hon, sir')
      topics.sub!('kg obe mp','kg, obe, mp')
      topics.sub!('house of commons ','house of commons, ')
      topics.sub!('wales representation in the','wales, representation')
      topics.sub!('palace of westminster union','palace of westminster, union')
      topics.sub!('in parliament','parliament')
      topics.sub!('groups ','groups, ')
      topics.sub!(' of ',', ')
      topics.sub!('scottish','scotland, scottish')
      topics.sub!('welsh','wales welsh')
      topics.sub!('northern, ireland','northern ireland, ireland')
      topics.sub!(', for ',', ')
      topics.sub!(', ireland ',', ireland, ')
      topics.sub!(', in, ',',')
      topics.sub!(', inc, ',',')
      topics.sub!('the, ','')
      topics.sub!('elections ','elections, ')
      topics.sub!('big, ben ','big ben, ')
      topics.sub!('privy, council','privy council, council')
      topics.sub!('privy, council','privy council, council')
      topics.sub!(', by, ',', ')
      topics.sub!(' to, ',', ')
      topics.sub!(', to ',', ')
      topics.sub!('prime, ministers question, time', 'prime minister, question time')
      topics.sub!('prime, ministers question time',  'prime minister, question time')
      topics.sub!('prime, ministers ',               'prime minister, ')
      topics.sub!('prime, ministers, ',              'prime minister, ')
      topics.sub!('prime, minister and ',            'prime minister, ')
      topics.sub!('prime, minister, ',               'prime minister, ')
      topics.sub!('prime, ministerial record, ',     'prime minister, record ')
      topics.sub!('prime, minister royal',           'prime minister, royal')
      topics.sub!(/prime, ministers?$/,              'prime minister')

      record.topic_list = topics
      puts topics

      record.save!
    end
  end

  def self.down
    Record.all.each do |record|
      record.topic_list = nil
      record.save!
    end
  end
end
