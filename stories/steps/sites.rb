steps_for(:sites) do
  When("the user goes to new site page") do 
    get "/sites/new"
  end
    
  When("the user submits form with url: $url") do |url|
     post "/sites", :site => {:url => url} 
  end
  
  Then("the user sees a form for creating a new site") do
      response.should be_success
      response.should have_tag("form[action='/sites']")
  end
  
  Then("a new site is created with url: $url") do |url|
    Site.find_by_url(url).should_not be_nil
  end
  
  Then("the user sees the site page with url: $url") do |url|
    follow_redirect!
    response.should be_success
    response.should have_tag("*", :text => Regexp.new("#{url}"))
  end
end