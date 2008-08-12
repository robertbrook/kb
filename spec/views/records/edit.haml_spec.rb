require File.dirname(__FILE__) + '/../../spec_helper'

describe "/record/edit.haml" do
  include RecordsHelper
  
  before do
    @record = mock_model(Record)
    assigns[:record] = @record
  end

  it "should render edit form" do
    render "/records/edit.haml"
    
    response.should have_tag("form[action=#{record_path(@record)}][method=post]") do
    end
  end
end