require File.dirname(__FILE__) + '/../../spec_helper'

describe "/record/edit.haml" do
  include RecordsHelper

  before do
    @record = mock_model(Record,
        :title=>'title',
        :suffix=>'suffix',
        :initial=>'E',
        :note_summary=>'Example',
        :web_page=>'url',
        :first_name=>'first',
        :middle_name=>'middle',
        :last_name=>'last',
        :display_title=> 'title first middle last suffix',
        :summary_attributes=>{'web_page'=>'url'},
        :attributes=>{},
        :core_attribute_names=>[],
        :note=>"note text")
    assigns[:record] = @record
  end

  it "should render edit form" do
    render "/records/edit.haml"
    response.should have_tag("form[action=#{record_path(@record)}][method=post]") do
    end
  end
end