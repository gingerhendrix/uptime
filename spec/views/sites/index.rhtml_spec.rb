require File.dirname(__FILE__) + '/../../spec_helper'

describe "/sites/index.rhtml" do
  include SitesHelper
  
  before do
    site_98 = mock_model(Site)
    site_98.should_receive(:url).and_return("MyString")
    site_99 = mock_model(Site)
    site_99.should_receive(:url).and_return("MyString")
    
    @user = mock_model(User)
    @user.stub!(:login).and_return("username")
    template.should_receive(:current_user).and_return(@user)
    assigns[:sites] = [site_98, site_99]
  end

  it "should render list of sites" do
    render "/sites/index.rhtml"
    response.should have_tag("tr>td", "MyString", 2)
  end
end

