module RecordsHelper

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