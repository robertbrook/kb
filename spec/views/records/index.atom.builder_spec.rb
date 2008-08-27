require File.dirname(__FILE__) + '/../../spec_helper'

describe "/records/index.haml" do
  include RecordsHelper

  before do
    @name = 'Name'
    @notes_summary = 'Example'
    @created = Date.parse('2008-08-24')
    @updated = Date.parse('2008-08-26')
    record = mock_model(Record,
      :name=>@name,
        :title=>'Exit',
        :suffix=>'Exit',
        :initial=>'E',
        :notes_summary=>@notes_summary,
        :web_page=>'url',
        :first_name=>'first',
        :middle_name=>'middle',
        :last_name=>'last',
        :summary_attributes=>{'web_page'=>'url'},
        :created_at=>@created,
        :updated_at=>@updated)

    assigns[:records] = [record]
  end

  def do_render
    render "/records/index.atom.builder", :layout=>'application'
  end

  it "should render record as an atom entry" do
    do_render
    response.should have_tag('entry') do
      with_tag('title', @name)
      with_tag('content', @notes_summary+'...')
      with_tag('published', @created.xmlschema)
      with_tag('updated', @updated.xmlschema)
    end
  end

end
