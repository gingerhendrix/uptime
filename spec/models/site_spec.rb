require File.dirname(__FILE__) + '/../spec_helper'

describe Site, "with fixtures loaded" do
  fixtures :sites
  
  before(:each) do
    
  end
  
  it "should have a non-empty collection of sites" do
    Site.find(:all).should_not be_empty
  end
  
  it "should find an exisiting site" do
    site = Site.find(sites(:google).id)
    site.should eql(sites(:google))
  end
  
end

describe Site, "with user" do
  fixtures :users
  before(:each) do
    @site = Site.new
    @site.url = "http://www.example.com"
    @site.user = users(:quentin)
  end

  it "should be valid" do
    @site.should be_valid
  end  
end

describe Site, "with no url" do
  before(:each) do
    @site = Site.new
  end

  it "should not be valid" do
    @site.should_not be_valid
  end
end

describe Site, "with url" do
  before(:each) do
    @site = Site.new
    @site.url = "http://www.example.com"
  end

  it "should be valid" do
    @site.should be_valid
  end
end
