require File.dirname(__FILE__) + '/../../spec_helper'

describe "/records/search.haml" do
  include RecordsHelper

  it "should render search form" do
    render "/records/search.haml"
    response.should have_tag("form[method=post]")
    response.should have_tag("input[id=search][name=search]")
    response.should have_tag("input[value=Search][type=submit]")
  end

end
