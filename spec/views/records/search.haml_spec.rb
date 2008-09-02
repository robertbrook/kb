require File.dirname(__FILE__) + '/../../spec_helper'
require File.dirname(__FILE__) + '/search_spec_helper'

describe "/records/search.haml" do
  include RecordsHelper

  before do
    @template = 'records/search.haml'
    assigns[:tags] = []
    assigns[:statuses] = []
  end

  it_should_behave_like "renders search form"
end
