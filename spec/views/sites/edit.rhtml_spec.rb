require File.dirname(__FILE__) + '/../../spec_helper'

describe "/sites/edit.rhtml" do
  include SitesHelper
  
  before do
    @site = mock_model(Site)
    @site.stub!(:url).and_return("MyString")
    assigns[:site] = @site
  end

  it "should render edit form" do
    render "/sites/edit.rhtml"
    
    response.should have_tag("form[action=#{site_path(@site)}][method=post]") do
      with_tag('input#site_url[name=?]', "site[url]")
    end
  end
end


