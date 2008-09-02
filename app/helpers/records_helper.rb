module RecordsHelper

  def encode_tag tag
    tag.gsub(' ','_')
  end

  def tags_list tags
    tags.collect do |tag|
      link_to(tag, url_for(:controller=>'records',:action=>'tag',:id=>encode_tag(tag)))
    end.join(', ')
  end

  def statuses_list statuses
    statuses.collect do |status|
      link_to(status, url_for(:controller=>'records',:action=>'status',:id=>encode_tag(status)))
    end.join(', ')
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
  def html_formatted_notes record
    formatted = h(record.notes.to_s.strip)
    formatted.gsub!(/(http:\/\/\S+)/, '<a href="\1">\1</a>')
    link_citation formatted, /HC Deb.+\sc\s?\.?\d+[W|G]?[S|H|C]?/
    link_citation formatted, /HL Deb.+\sc\s?\.?\d+[W|G]?[S|H|C]?/
    link_citation formatted, /HC Deb.+cc\s?\d+-\d+[W|G]?[S|H|C]?/
    link_citation formatted, /HL Deb.+cc\s?\d+-\d+[W|G]?[S|H|C]?/

    formatted.gsub!("\r\n","\n")
    formatted.gsub!("\n\n","</p><p>")
    formatted.gsub!("\n",'<br />')
    "<p>#{formatted}</p>"
  end
end