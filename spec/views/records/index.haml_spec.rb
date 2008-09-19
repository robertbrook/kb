require File.dirname(__FILE__) + '/../../spec_helper'

describe "/records/index.haml" do
  include RecordsHelper

  before do
    record = mock_model(Record,
      :name=>'Name',
        :title=>'Exit',
        :suffix=>'Exit',
        :initial=>'E',
        :notes_summary=>'Example',
        :web_page=>'url',
        :first_name=>'first',
        :middle_name=>'middle',
        :last_name=>'last',
        :summary_attributes=>{'web_page'=>'url'})

    assigns[:records] = [record]
    template.stub!(:will_paginate).and_return ''
  end

  def do_render
    render "/records/index.haml"
  end
  it "should render list of records" do
    do_render
  end

  it 'should add auto discovery of atom feed' do
    render "/records/index.haml", :layout=>'application'
    response.should have_tag("link[title=?][type=?][rel=?]", 'ATOM', 'application/atom+xml', 'alternate')
  end

  describe 'user is admin' do
    before do
      assigns[:is_admin] = true
    end
    it 'should show Edit link' do
      do_render
      response.should have_tag('a','Edit')
    end
    it 'should not show Destroy link' do
      do_render
      response.should_not have_tag('a','Destroy')
    end
  end
  describe 'user is not admin' do
    before do
      assigns[:is_admin] = false
    end
    it 'should not show Edit link' do
      do_render
      response.should_not have_tag('a','Edit')
    end
    it 'should not show Destroy link' do
      do_render
      response.should_not have_tag('a','Destroy')
    end
  end
end
