require File.dirname(__FILE__) + "/helper"

steps_for(:records) do
  
  Given("a record with the id '$id'") do |id|
    @record = Record.find_by_id(id)
  end
  # When I view the front page
  # Then the record should appear
  # And it should be linked to
  
end

with_steps_for(:records) do
  run_local_story("record")
end