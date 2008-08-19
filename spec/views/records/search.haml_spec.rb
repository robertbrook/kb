require File.dirname(__FILE__) + '/../../spec_helper'

describe "/records/search.haml" do
  include RecordsHelper

  it "should render search form" do
    render "/records/search.haml"
  end
end
