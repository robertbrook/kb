require File.dirname(__FILE__) + '/../../spec_helper'
require File.dirname(__FILE__) + '/search_spec_helper'

describe "/records/search_results.haml" do
  include RecordsHelper

  before do
    @template = 'records/search_results.haml'
    @searched_for = 'Group'
    assigns[:term] = @searched_for
  end

  it_should_behave_like "renders search form"

  def do_render
    render @template
  end

  describe 'when there are no results' do
    before do
      assigns[:records] = []
    end
    it "should show message that records are not found" do
      do_render
      response.should have_tag('p', "Your search -\n  Group\n   - did not match any item names.")
    end
  end

  describe 'when there are results' do
    before do
      @name = 'All Party Group'
      @notes = 'The all party group...'
      @record = mock(Record, :name => @name, :notes => @notes, :id=>123)
      records = [@record]
      assigns[:records] = records
      assigns[:words_to_highlight] = []
    end
    it 'should show result name in a heading' do
      do_render
      response.should have_tag("h4[class=name]", @name)
    end
    it 'should show result name as a link' do
      do_render
      response.should have_tag("a[href=#{record_path(@record)}]", @name)
    end
    it 'should show result notes summary' do
      do_render
      response.should have_tag("div[class=notes]", 'The all party ...')
    end
  end
end
