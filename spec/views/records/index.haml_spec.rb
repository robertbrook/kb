require File.dirname(__FILE__) + '/../../spec_helper'

describe "/records/index.haml" do
  include RecordsHelper

  before do
    record_98 = mock_model(Record,:note_summary=>'Example',:summary_attributes=>{})
    record_99 = mock_model(Record,:note_summary=>nil,:summary_attributes=>{'web_page'=>'url'})

    assigns[:records] = [record_98, record_99]
  end

  it "should render list of records" do
    render "/records/index.haml"
  end
end
