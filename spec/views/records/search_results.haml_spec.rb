require File.dirname(__FILE__) + '/../../spec_helper'
require File.dirname(__FILE__) + '/search_spec_helper'

describe "/records/search_results.haml" do
  include RecordsHelper

  before do
    @template = 'records/search_results.haml'
    @searched_for = 'term'
    assigns[:term] = @searched_for
  end

  it_should_behave_like "renders search form"

end
