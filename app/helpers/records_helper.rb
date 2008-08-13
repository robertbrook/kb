module RecordsHelper

  def link_to_web_page(record)
    record.web_page.blank? ? '' : link_to(record.web_page[0..30]+'...', record.web_page)
  end

  def format_notes(record)
    formatted = record.note.strip
    formatted.gsub!(/(http:\/\/\S+)/, '<a href="\1">\1</a>')
    formatted.gsub!("\r\n\r\n","</p><p>")
    formatted.gsub!("\r\n",'<br />')
    "<p>#{formatted}</p>"
  end
end