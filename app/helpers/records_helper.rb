module RecordsHelper

  def link_to_web_page(record)
    record.web_page ? link_to(record.web_page, record.web_page) : ''
  end
end