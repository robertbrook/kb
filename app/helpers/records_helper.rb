module RecordsHelper

  def encode_tag tag
    tag.gsub(' ','_')
  end

  def weighted_tags_list tags
    tags.collect do |tag|
      link_text = "#{tag.name}"
      url = url_for(:controller=>'records',:action=>'tag',:id=>encode_tag(tag.name))
      weight = (Math.log10(tag.taggings.size)*20).to_i
      weight = weight.next if (weight < 14)
      weight = weight.next if (weight < 13)
      weight = weight.next if (weight < 12)
      weight = weight.next if (weight < 11)
      weight = weight.next if (weight < 10)
      weight = weight - 3 if (weight > 29)
      link_to(link_text, url, :style=>"font-size: #{weight}px")
      end.join(' ')
  end

  def tags_list tags
    tags.collect do |tag|
      link_to(tag, url_for(:controller=>'records',:action=>'tag',:id=>encode_tag(tag)), {:class => "tag"})
    end.join(' ')
  end

  def statuses_list statuses
    statuses.collect do |status|
      link_to(status, url_for(:controller=>'records',:action=>'status',:id=>encode_tag(status)), {:class => "tag"})
    end.join(' ')
  end

  def link_to_record record
    link_to(record.name, record_path(record))
  end

  def link_to_web_page(record)
    record.web_page.blank? ? '' : link_to(record.web_page[0..30]+'...', record.web_page)
  end

  def edit_name_fields record
    edit_field(@record, 'title') +
    edit_field(@record, 'first_name') +
    edit_field(@record, 'middle_name') +
    edit_field(@record, 'last_name') +
    edit_field(@record, 'suffix')
  end

  def edit_field(record, attribute, options={})
    if record.send(attribute.to_sym).blank?
      record.send("#{attribute}=", '____')
    end
    in_place_editor_field(:record, attribute, {}, options)
  end

  def link_citation text, pattern
    text.scan(pattern).each do |match|
      match = match[0] if match.is_a?(Array)
      text.sub!(match, "<a href=\"http://hansard.millbanksystems.com/search/#{match}\">#{match}</a>")
    end
  end

  def html_formatted_notes record, options={}
    add_links = options.has_key?(:add_links) ? options[:add_links] : true
    formatted = h(record.notes.to_s.strip)
    if add_links
      formatted.gsub!(/(http:\/\/\S+)/, '<a href="\1">\1</a>')
      formatted.gsub!(/<a href="(\S+)&gt;">(\S+)&gt;<\/a>/, '<a href="\1">\2</a>&gt;')
      link_citation formatted, /HC Deb.+\sc\s?\.?\d+[W|G]?[S|H|C]?/
      link_citation formatted, /HL Deb.+\sc\s?\.?\d+[W|G]?[S|H|C]?/
      link_citation formatted, /HC Deb.+cc\s?\d+-\d+[W|G]?[S|H|C]?/
      link_citation formatted, /HL Deb.+cc\s?\d+-\d+[W|G]?[S|H|C]?/
    end

    formatted.gsub!("\r\n","\n")
    formatted.gsub!("\n\n","</p><p>")
    formatted.gsub!("\n",'<br />')
    "<p>#{formatted}</p>"
  end


  def excerpts text, term, part_match=true
    return '' unless text
    text = text.gsub(/<p id='[\d\.]*[a-z]*'>/, ' ').gsub('<p>',' ').gsub('</p>',' ').gsub('<i>','').gsub('</i>','')
    excerpts = nil

    if text.include? term
      text = tidy_excerpt(text, term, 120)
      excerpts = highlight(text, term)
    elsif text.include? term.titlecase
      text = tidy_excerpt(text, term.titlecase, 120)
      excerpts = highlight(text, term.titlecase)
    elsif part_match
      terms = term.split
      count = 0
      terms.each { |term| count += 1 if text.include?(term) }

      char_count = (([1,12-(count*2)].max / 12.0) * 120).to_i #/
      texts = []

      terms.each do |term|
        if !add_term(text, texts, char_count, term)
          if !add_term(text, texts, char_count, term.downcase)
            add_term text, texts, char_count, term.titlecase
          end
        end
      end

      terms.each do |term|
        texts = texts.collect do |text|
          if text.include?(' '+term) || text.include?(' '+term.titlecase) || text.include?(' '+term.downcase)
            highlight(text, ' '+term)
          else
            text
          end
        end
      end
      excerpts = texts.join("<br></br>")
    else
      excerpts = ''
    end

    excerpts
  end

  def tidy_excerpt text, term, chars
    begin
      text = excerpt text, term, chars
    rescue Exception=> e
      return ''
    end
    text.gsub(/\.\.\.[A-Za-z0-9,\.\?']*[ -]/, '... ').gsub(/ [A-Za-z0-9]*\.\.\./, ' ...') # /
  end

  def add_term text, texts, char_count, term
    present = text.include?(' '+term)
    texts << tidy_excerpt(text, ' '+term, char_count) if present
    present
  end

  def highlights text, words_to_highlight
    unless words_to_highlight.empty?
      words_to_highlight.each do |term|
        if text.include?(' '+term) || text.include?(' '+term.titlecase) || text.include?(' '+term.downcase)
          text = highlight(text, ' '+term)
        end
      end
    end
    text
  end

end