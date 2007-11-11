require File.dirname(__FILE__) + '/../../spec_helper'

describe "/sites/show.rhtml" do
  include SitesHelper
  
  before do
    @site = mock_model(Site)
    @site.stub!(:url).and_return("MyString")
    
    assigns[:site] = @site
  end

  it "should render attributes in <p>" do
    render "/sites/show.rhtml"
    response.should have_text(/MyString/)
  end

end

