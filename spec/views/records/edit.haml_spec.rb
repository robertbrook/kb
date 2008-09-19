require File.dirname(__FILE__) + '/../../spec_helper'

describe "/record/edit.haml" do
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
    assigns[:record] = @record
    @record.stub!(:notes=).with("<p>notes text</p>")
  end

  def do_render
    render "/records/edit.haml"
  end
  it "should render edit form" do
    @record.should_receive(:notes=).with("<p>notes text</p>")
    do_render
    response.should have_tag("form[action=#{record_path(@record)}][method=post]") do
    end
  end
  it 'should show Destroy link' do
    do_render
    response.should have_tag('a','Destroy item')
  end
end