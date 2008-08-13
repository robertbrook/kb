module RecordsHelper

  def link_to_web_page(record)
    record.web_page ? link_to(record.web_page[0..30]+'...', record.web_page) : ''
  end
end