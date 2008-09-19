require File.dirname(__FILE__) + '/../../spec_helper'

describe "/records/show.haml" do
  include RecordsHelper

  before do
    @record = Record.new({
        :name => 'All-Party Groups: Subject',
        :use_check_by_date => false,
        :web_page=>'url'})

    assigns[:record] = @record
  end

  def do_render
    render "/records/show.haml"
  end
  it "should render attributes" do
    render "/records/show.haml"
  end

  describe 'user is admin' do
    before do
      assigns[:is_admin] = true
      do_render
    end
    it 'should show Edit link' do
      response.should have_tag('a','Edit')
    end
    it 'should not show Destroy link' do
      response.should_not have_tag('a','Destroy')
    end
    it 'should have in_place_editor_field' do
      response.should have_tag('span.in_place_editor_field')
    end
  end
  describe 'user is not admin' do
    before do
      assigns[:is_admin] = false
      do_render
    end
    it 'should not show Edit link' do
      response.should_not have_tag('a','Edit')
    end
    it 'should not show Destroy link' do
      response.should_not have_tag('a','Destroy')
    end
    it 'should not have in_place_editor_field' do
      response.should_not have_tag('span.in_place_editor_field')
    end
  end
end

