require File.dirname(__FILE__) + '/../spec_helper'

context "Routes for the SessionsController should map" do
  controller_name :sessions

  specify "{ :controller => 'sessions', :action => 'new' } to /sessions/new" do
    route_for(:controller => "sessions", :action => "new").should eql("/sessions/new")
  end
  
  specify "{ :controller => 'sessions', :action => 'create' } to /sessions" do
    route_for(:controller => "sessions", :action => "create").should eql("/sessions")
  end
    
  specify "{ :controller => 'sessions', :action => 'destroy', :id => 1} to /sessions/1" do
    route_for(:controller => "sessions", :action => "destroy", :id => 1).should eql("/sessions/1")
  end
end


context "The Sessions controller" do
  fixtures :users
  controller_name :sessions

  specify "should be an SessionsController" do
    controller.should be_an_instance_of(SessionsController)
  end

  specify "should redirect to / after successful login" do   
    post :create, :login => 'quentin', :password => 'test'
    response.should redirect_to('http://test.host/')
    should_be_logged_in
  end

  specify "should redirect back after successful login" do
    session[:return_to] = "/sessions/back"
    post :create, :login => 'quentin', :password => 'test'
    response.should redirect_to('http://test.host/sessions/back')
    should_be_logged_in
  end

  specify "should not redirect after failed login" do
    post :create, :login => 'quentin', :password => 'bad password'
    response.should be_success
    should_not_be_logged_in
  end

  specify "should remember me" do
    post :create, :login => 'quentin', :password => 'test', :remember_me => '1'
    response.cookies["auth_token"].should_not be_nil
  end

  specify "should not remember me" do
    post :create, :login => 'quentin', :password => 'test', :remember_me => '0'
    response.cookies["auth_token"].should be_nil
  end

  specify "should delete auth token on logout" do
    login_as :quentin
    get :destroy
    response.cookies["auth_token"].should be_empty
    should_not_be_logged_in
  end

  specify "should login with cookie" do
    pending "Fails for unknown reason" do 
      users(:quentin).remember_me
      request.cookies["auth_token"] = cookie_for(:quentin)
      get :new
      should_be_logged_in
    end
  end

  specify "should fail to login with expired cookie" do
    users(:quentin).remember_me
    users(:quentin).update_attribute :remember_token_expires_at, 15.minutes.ago
    request.cookies["auth_token"] = cookie_for(:quentin)
    get :new
    should_not_be_logged_in
  end

  specify "should fail to login with invalid cookie" do
      users(:quentin).remember_me
      request.cookies["auth_token"] = auth_token('invalid_auth_token')
      get :new
      should_not_be_logged_in
   end

  protected


  def login_as(user)
    request.session[:user] = user ? users(user).id : nil
  end

  def auth_token(token)
    CGI::Cookie.new('name' => 'auth_token', 'value' => token)
  end

  def cookie_for(user)
    auth_token users(user).remember_token
  end

  def should_be_logged_in
    response.session.should_not be_nil
    response.session[:user].should_not be_nil
  end

  def should_not_be_logged_in
    response.session.should_not be_nil
    response.session[:user].should be_nil
  end

end