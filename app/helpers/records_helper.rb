module RecordsHelper

  def link_to_web_page(record)
    record.web_page.blank? ? '' : link_to(record.web_page[0..30]+'...', record.web_page)
  end

  def format_notes(record)
    formatted = record.note.to_s.strip
    formatted.gsub!(/(http:\/\/\S+)/, '<a href="\1">\1</a>')
    formatted.gsub!("\r\n","\n")
    formatted.gsub!("\n\n","</p><p>")
    formatted.gsub!("\n",'<br />')
    "<p>#{formatted}</p>"
  end

  def edit_field(record, attribute, options={})
    if record.send(attribute.to_sym).blank?
      record.send("#{attribute}=", '____')
    end
    in_place_editor_field(:record, attribute, {}, options)
  end
end