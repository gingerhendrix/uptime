require File.dirname(__FILE__) + '/../spec_helper'

context "Routes for the UsersController should map" do
  controller_name :users

  specify "{ :controller => 'users', :action => 'new' } to /users/new" do
    route_for(:controller => "users", :action => "new").should eql("/users/new")
  end
  
  specify "{ :controller => 'users', :action => 'create' } to /users" do
    route_for(:controller => "users", :action => "create").should eql("/users")
  end
    
  specify "{ :controller => 'users', :action => 'destroy', :id => 1} to /users/1" do
    route_for(:controller => "users", :action => "destroy", :id => 1).should eql("/users/1")
  end
end

context "The Users controller on signup" do
  controller_name :users
  
  specify "should be an UsersController" do
    controller.should be_an_instance_of( UsersController)
  end
  
  specify "should allow signup" do
    lambda do 
      create_user
      response.should redirect_to('/')
    end.should change(User,:count).by(1)
  end

  specify "should require login on signup" do
    create_user :login => nil 
    response.should be_success
    assigns(:user).should have_at_least(1).errors_on(:login)
  end

  specify "should require password on signup" do
    create_user :password => nil
    response.should be_success
    assigns(:user).should have_at_least(1).errors_on(:password)
  end

  specify "should require password confirmation on signup" do
    create_user :password_confirmation => nil 
    response.should be_success
    assigns(:user).should have_at_least(1).errors_on(:password_confirmation)
  end

  specify "should require email on signup" do
    create_user :email => nil 
    response.should be_success
    assigns(:user).should have_at_least(1).errors_on(:email)
  end
  
  specify "should fall back to new if save failed" do
    post :create, :user => {}
    response.should render_template('new')
    assigns(:user).should have_at_least(1).errors
  end
  
  protected
  def create_user(options = {})
    post :create, :user => { :login => 'quire', :email => 'quire@example.com', :password => 'quire', :password_confirmation => 'quire' }.merge(options)
  end
end
