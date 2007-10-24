require File.dirname(__FILE__) + '/../../spec_helper'

describe "/sites/new.rhtml" do
  include SitesHelper
  
  before do
    @site = mock_model(Site)
    @site.stub!(:new_record?).and_return(true)
    @site.stub!(:url).and_return("MyString")
    assigns[:site] = @site
  end

  it "should render new form" do
    render "/sites/new.rhtml"
    
    response.should have_tag("form[action=?][method=post]", sites_path) do
      with_tag("input#site_url[name=?]", "site[url]")
    end
  end
end


