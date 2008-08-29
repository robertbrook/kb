module RecordsHelper

  def category_list record
    record.category_list.collect do |category|
      link_to(category, url_for(:controller=>'records',:action=>'category',:id=>category))
    end.join(', ')
  end

  def topics_list
    topics = Tagging.find(:all,:conditions=>'context = "topics"', :include=>'tag').collect(&:tag)
    topics = topics.select {|t| t.taggings.size > 1}
    topics = topics.collect(&:name).uniq.sort
    topics.collect do |topic|
      link_to(topic, url_for(:controller=>'records',:action=>'topic',:id=>topic))
    end.join(', ')
  end

  def categories_list
    categories = Tagging.find(:all,:conditions=>'context = "categories"', :include=>'tag').collect(&:tag)
    categories = categories.select {|t| t.taggings.size > 0}
    categories = categories.collect(&:name).uniq.sort
    categories.collect do |category|
      link_to(category, url_for(:controller=>'records',:action=>'category',:id=>category))
    end.join(', ')
  end

  def topic_list record
    record.topic_list.collect do |topic|
      link_to(topic, url_for(:controller=>'records',:action=>'topic',:id=>topic))
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

  def html_formatted_notes record
    formatted = h(record.notes.to_s.strip)
    formatted.gsub!(/(http:\/\/\S+)/, '<a href="\1">\1</a>')
    formatted.gsub!("\r\n","\n")
    formatted.gsub!("\n\n","</p><p>")
    formatted.gsub!("\n",'<br />')
    "<p>#{formatted}</p>"
  end
end