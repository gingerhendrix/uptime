require File.dirname(__FILE__) + '/../../spec_helper'

describe "/index/index", "without authenticated user" do
    before do
     template.stub!(:current_user).and_return(nil)
    end

    it "should have title 'Uptime'" do
      render "/index/index"
      response.should have_tag('title', 'Uptime')
    end
    
    it "should show flash[:notice]" do
      flash[:notice] = "Flash Notice"
      render "/index/index"
      response.should have_tag('#notice', "Flash Notice")
    end
    
    it "should link to registration page" do
      render "/index/index"
      response.should have_tag('a[href="/users/new"]')
    end
    
    it "should link to login page" do
      render "/index/index"
      response.should have_tag('a[href="/sessions/new"]')
    end
end


describe "/index/index", "with authenticated user" do
  before do
     @user = mock("user")
     @user.stub!(:login).and_return("username")
     template.stub!(:current_user).and_return(@user)
  end
  
  it "should show link to sites" do
      render "/index/index"
      response.should have_tag('a[href="/sites"]')
  end
end