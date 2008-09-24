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

    describe 'and there is no spelling correction assigned' do
      it "should not show message suggesting spelling correction" do
        do_render
        response.should_not have_tag('p.spelling_correction')
      end
    end
    describe 'and there is a spelling correction assigned' do
      before do
        assigns[:spelling_correction] = 'committee'
      end
      it "should show message suggesting spelling correction" do
        do_render
        response.should have_tag('p.spelling_correction', "Did you mean:\n  committee")
      end
    end
  end

  describe 'when there are results' do
    before do
      @name = 'All Party Group'
      @notes = 'The all party group...'
      @record = mock(Record, :name => @name, :notes => @notes, :id=>123)
      @records = [@record]
      assigns[:records] = @records
      assigns[:words_to_highlight] = []
      template.stub!(:will_paginate).and_return ''
    end
    it 'should generate pagination links' do
      template.should_receive(:will_paginate).with(@records).and_return ''
      do_render
    end
    it 'should show result name in a heading' do
      do_render
      response.should have_tag("span[class=name]", @name)
    end
    it 'should show result name as a link' do
      do_render
      response.should have_tag("a[href=#{record_path(@record)}]", @name)
    end
    it 'should show result notes summary' do
      do_render
      response.should have_tag("span[class=excerpt]", 'The all party ...')
    end
  end
end
