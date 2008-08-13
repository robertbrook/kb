require File.join(File.dirname(__FILE__), "helper") 

Story "Anonymous visitor to the site", %{
  As an anonymous visitor
  I want to visit public pages
}, :type => RailsStory do

  Scenario "Starts at home page and drills down" do
    When "visiting home page" do
      get "/"
  end

    Then "user should see home page" do
      response.should render_template('base/home')
    end

    When "he clicks on the About link" do
      get "/about"
    end

    Then "user should see the About page" do 
      response.should render_template('base/about')
    end 

  end

end