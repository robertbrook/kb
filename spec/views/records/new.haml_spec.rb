require File.dirname(__FILE__) + '/../../spec_helper'

describe "/records/new.haml" do
  include RecordsHelper
  
  before do
    @record = mock_model(Record)
    @record.stub!(:new_record?).and_return(true)
    assigns[:record] = @record
  end

  it "should render new form" do
    render "/records/new.haml"
    
    response.should have_tag("form[action=?][method=post]", records_path) do
    end
  end
end
