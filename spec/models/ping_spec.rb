require File.dirname(__FILE__) + '/../spec_helper'

describe Ping do
  before(:each) do
    @ping = Ping.new
    @ping.site = mock_model(Site)
    @ping.response_time = 123
    @ping.response_code = 200
    @ping.response_text = "Success"
  end
  
  it "should be valid" do
    @ping.should be_valid
  end

  it "should not be valid without site" do
    @ping.site = nil
    @ping.should_not be_valid
  end
  
  it "should not be valid without response_time" do
    @ping.response_time = nil
    @ping.should_not be_valid
  end
  
  it "should not be valid without response_code" do
    @ping.response_code = nil
    @ping.should_not be_valid
  end
  
  it "should not be valid without response_text" do
    @ping.response_text = nil
    @ping.should_not be_valid
  end
  
  it "should have created_at after creation" do
    @ping.created_at.should be_nil
    @ping.save!
    @ping.created_at.should_not be_nil
  end
  
end

describe Ping, "when saved" do
  before(:each) do
    @ping = Ping.new
    @ping.site = mock_model(Site)
    @ping.response_time = 123
    @ping.response_code = 200
    @ping.response_text = "Success"
    @ping.save!
  end
  
  it "should not be able to change response_time" do
    lambda { 
      @ping.response_time = 234 
    }.should raise_error(ImmutableErrors::ImmutableAttributeError)
  end
  
    it "should not be able to change response_text" do
    lambda { 
      @ping.response_text = "Server Error" 
    }.should raise_error(ImmutableErrors::ImmutableAttributeError)
  end
  
  it "should not be able to change response_code" do
    lambda { 
      @ping.response_code = 500 
    }.should raise_error(ImmutableErrors::ImmutableAttributeError)
  end
  
end
