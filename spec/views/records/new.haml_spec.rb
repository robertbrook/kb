require File.dirname(__FILE__) + '/../../spec_helper'

describe "/records/new.haml" do
  include RecordsHelper

  before do
    @record = mock_model(Record,
        :initial=>'E',
        :notes_summary=>'Example',
        :other_notes=>'',
        :summary=>'Example',
        :web_page=>'url',
        :name =>'All-Party Group: Subject',
        :summary_attributes=>{'web_page'=>'url'},
        :use_check_by_date => false,
        :check_by_date => Date.new(1999,1,1),
        :attributes=>{},
        :status_list=>[],
        :tag_list=>[],
        :core_attribute_names=>[],
        :notes=>"notes text")
    @record.stub!(:new_record?).and_return(true)
    assigns[:record] = @record
    @record.stub!(:notes=).with("<p>notes text</p>")
  end

  it "should render new form" do
    render "/records/new.haml"

    response.should have_tag("form[action=?][method=post]", records_path) do
    end
  end
end
