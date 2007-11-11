require File.dirname(__FILE__) + '/../spec_helper'

require "net/http"

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
  
  it "should authorize owner" do
    @site.authorize?(users(:quentin)).should be(true)
  end
  
  it "should not authorize non owner" do
    @site.authorize?(users(:aaron)).should be(false)
  end
end

describe Site do
  before(:each) do
    @site = Site.new
    @site.url = "http://www.example.com"
  end
  
  it "should be valid" do
    @site.should be_valid
  end
  
  it "should not be valid without url" do
    @site.url = nil
    @site.should_not be_valid
  end
  
  it "should build a ping with the site set" do
    @site.save!
    @site.build_ping.site.id.should be(@site.id)
  end

end

describe Site, "ping" do
  fixtures :sites
  
  before(:each) do
    @site = sites(:google)
    
    @response = {:code => "200", :message => "OK"}
    @response.stub!(:message).and_return("OK")
    @response.stub!(:code).and_return(200)
    Net::HTTP.stub!(:get_response).and_return(@response)
  end
  
  it "should return a value" do
    ping = @site.ping!
    ping.should_not be(nil)
  end
  
  it "should return a Ping" do
    ping = @site.ping!
    ping.should be_an_instance_of(Ping)
  end
  
  it "should return a Ping which is saved" do
    ping = @site.ping!
    ping.new_record?.should be(false)
  end
  
  it "should return a Ping which is valid" do
    ping = @site.ping!
    ping.valid?.should be(true)
  end
  
  it "should call http open" do #required only so that we know stubbing is working for other tests
    Net::HTTP.should_receive(:get_response).with(URI.parse(@site.url)).and_return(@response)
    @site.ping!
  end
  
  it "should time the response and save it in model" do
    time = Time.now
    Time.should_receive(:now).at_least(:twice).and_return(time, time+5)
    ping = @site.ping!
    ping.response_time.should eql(5)
  end
  
  it "should save the response code and response message" do
    @response.should_receive(:code).and_return(200);
    @response.should_receive(:message).and_return("OK");
    ping = @site.ping!
    ping.response_code.should eql(200)
    ping.response_text.should eql("OK")
  end
  
  
end