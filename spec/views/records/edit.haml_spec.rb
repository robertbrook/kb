require File.dirname(__FILE__) + '/../../spec_helper'

describe "/record/edit.haml" do
  include RecordsHelper

  before do
    @record = mock_model(Record,
        :title=>nil,
        :suffix=>'suffix',
        :initial=>'E',
        :notes_summary=>'Example',
        :web_page=>'url',
        :first_name=>'first',
        :middle_name=>'middle',
        :last_name=>'last',
        :display_title=> 'title first middle last suffix',
        :summary_attributes=>{'web_page'=>'url'},
        :use_check_by_date => false,
        :check_by_date => Date.new(1999,1,1),
        :attributes=>{},
        :category_list=>[],
        :core_attribute_names=>[],
        :notes=>"notes text")
    assigns[:record] = @record
  end

  it "should render edit form" do
    render "/records/edit.haml"
    response.should have_tag("form[action=#{record_path(@record)}][method=post]") do
    end
  end
end