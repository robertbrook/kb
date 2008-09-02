class PopulateTopicTags < ActiveRecord::Migration
  def self.up
    Record.all.each do |record|
      tags = []
      [:title, :first_name, :middle_name, :last_name, :suffix].each do |topic_attribute|
        topic = record.send(topic_attribute)
        unless topic.blank?
          topic = topic.strip.downcase.strip.gsub(/:^$/,', ').gsub('/',', ').gsub(/[^a-z^-^ ^,]/,'').squeeze(' ').strip
          unless topic.blank? || topic == '-'
            tags << topic
          end
        end
      end
      tags = tags.join(', ')

      tags.sub!('select, committees,', 'select committees, committees,')
      tags.sub!('select, committees ', 'select committees, committees, ')
      tags.sub!(' - in,',',')
      tags.sub!('bill committee', 'committee, bill committee')
      tags.sub!('constituents ', 'constituents, ')
      tags.sub!('commission ', 'commission, ')
      tags.sub!('committee ', 'committee, ')
      tags.sub!('reading committee', 'committee, reading committee')
      tags.sub!('committees definition','committees, definition')
      tags.sub!('standing committees','committees, standing committees')
      tags.sub!('statues members','statues, members')
      tags.sub!('meps access to','meps, access to')
      tags.sub!('senior salaries review body ssrb','salaries, review body, ssrb')
      tags.sub!('senior salaries review body ssrb','salaries, review body, ssrb')
      tags.sub!('queens speech amendment on the', 'queens speech, amendment on the')
      tags.sub!('mps returned for two','mps, returned for two')
      tags.sub!('seats won by country', 'seats, won by country')
      tags.sub!('private members bills','bills, members, private members bills')
      tags.sub!('constituencies ','constituencies, ')
      tags.sub!('bills time spent', 'bills, time spent')
      tags.sub!('history of parliament','history, parliament')
      tags.sub!('orders and regulations','orders, regulations')
      tags.sub!('visiting each others','visiting')
      tags.sub!('govt', 'government')
      tags.sub!('defeats ', 'defeats, ')
      tags.sub!('to contact ministersgovernment','contact, ministers, government')
      tags.sub!('depts','departments')
      tags.sub!(' grand, committee', ', grand committee, committee')
      tags.sub!('ii house of commons evacuation','house of commons, evacuation')
      tags.sub!('ii end europe','europe')
      tags.sub!('rt hon sir','rt hon, sir')
      tags.sub!('kg obe mp','kg, obe, mp')
      tags.sub!('house of commons ','house of commons, ')
      tags.sub!('wales representation in the','wales, representation')
      tags.sub!('palace of westminster union','palace of westminster, union')
      tags.sub!('in parliament','parliament')
      tags.sub!('groups ','groups, ')
      tags.sub!(' of ',', ')
      tags.sub!('scottish','scotland, scottish')
      tags.sub!('welsh','wales welsh')
      tags.sub!('northern, ireland','northern ireland, ireland')
      tags.sub!(', for ',', ')
      tags.sub!(', ireland ',', ireland, ')
      tags.sub!(', in, ',',')
      tags.sub!(', inc, ',',')
      tags.sub!('the, ','')
      tags.sub!('elections ','elections, ')
      tags.sub!('big, ben ','big ben, ')
      tags.sub!('privy, council','privy council, council')
      tags.sub!('privy, council','privy council, council')
      tags.sub!(', by, ',', ')
      tags.sub!(' to, ',', ')
      tags.sub!(', to ',', ')
      tags.sub!('prime, ministers question, time', 'prime minister, question time')
      tags.sub!('prime, ministers question time',  'prime minister, question time')
      tags.sub!('prime, ministers ',               'prime minister, ')
      tags.sub!('prime, ministers, ',              'prime minister, ')
      tags.sub!('prime, minister and ',            'prime minister, ')
      tags.sub!('prime, minister, ',               'prime minister, ')
      tags.sub!('prime, ministerial record, ',     'prime minister, record ')
      tags.sub!('prime, minister royal',           'prime minister, royal')
      tags.sub!(/prime, ministers?$/,              'prime minister')

      record.tag_list = tags
      puts tags

      record.save!
    end
  end

  def self.down
    Record.all.each do |record|
      record.tag_list = nil
      record.save!
    end
  end
end
