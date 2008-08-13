require File.dirname(__FILE__) + '/../../spec_helper'

describe "/records/show.haml" do
  include RecordsHelper

  before do
    @record = Record.new({
        :first_name => 'All-Party',
        :middle_name => 'Groups:',
        :last_name => 'Subject',
        :title => 'The',
        :suffix => '(suffix)',
        :web_page=>'url'})

    assigns[:record] = @record
  end

  it "should render attributes" do
    render "/records/show.haml"
  end
end

