require File.dirname(__FILE__) + '/../../spec_helper'

describe "/records/index.haml" do
  include RecordsHelper

  before do
    record = mock_model(Record,
        :title=>'Exit',
        :suffix=>'Exit',
        :initial=>'E',
        :notes_summary=>'Example',
        :web_page=>'url',
        :first_name=>'first',
        :middle_name=>'middle',
        :last_name=>'last',
        :summary_attributes=>{'web_page'=>'url'})

    assigns[:records] = [record]
  end

  it "should render list of records" do
    render "/records/index.haml"
  end
end
