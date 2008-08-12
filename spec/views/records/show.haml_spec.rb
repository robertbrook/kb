require File.dirname(__FILE__) + '/../../spec_helper'

describe "/records/show.haml" do
  include RecordsHelper
  
  before do
    @record = mock_model(Record)

    assigns[:record] = @record
  end

  it "should render attributes in <p>" do
    render "/records/show.haml"
  end
end

