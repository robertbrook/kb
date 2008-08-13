require File.dirname(__FILE__) + '/../../spec_helper'

describe "/records/show.haml" do
  include RecordsHelper

  before do
    @record = mock_model(Record,
        :title=>'Exit',
        :suffix=>'Exit',
        :initial=>'E',
        :note=>'Example',
        :web_page=>'url',
        :first_name=>'first',
        :middle_name=>'middle',
        :last_name=>'last',
        :summary_attributes=>{'web_page'=>'url'})

    assigns[:record] = @record
  end

  it "should render attributes in <p>" do
    render "/records/show.haml"
  end
end

