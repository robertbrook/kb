require File.dirname(__FILE__) + '/../../spec_helper'

describe "/records/index.haml" do
  include RecordsHelper

  before do
    record = mock_model(Record,
        :initial=>'E',
        :note_summary=>'Example',
        :web_page=>'url',
        :summary_attributes=>{'web_page'=>'url'})

    assigns[:records] = [record]
  end

  it "should render list of records" do
    render "/records/index.haml"
  end
end
