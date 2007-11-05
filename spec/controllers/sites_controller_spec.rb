require File.dirname(__FILE__) + '/../spec_helper'

module SitesControllerSpecHelper
 
  def mock_sites_and_user
    @site = mock_model(Site)
    @sites = [@site]
    @site.stub!(:authorize?).and_return(true)
    @site.stub!(:user=).and_return(true)
    
    @user = mock_model(User)
    
    @user.stub!(:find_sites).and_return(@sites)
  
    controller.stub!(:current_user).and_return(@user)
  end
  
  def do_action
    if self.respond_to?(:do_get, true)
      do_get
    elsif self.respond_to?(:do_post, true)
      do_post
    elsif self.respond_to?(:do_put, true)
      do_put
    elsif self.respond_to?(:do_delete, true)
      do_delete
    end
  end
  
end

describe SitesController, "#route_for" do

  it "should map { :controller => 'sites', :action => 'index' } to /sites" do
    route_for(:controller => "sites", :action => "index").should == "/sites"
  end
  
  it "should map { :controller => 'sites', :action => 'new' } to /sites/new" do
    route_for(:controller => "sites", :action => "new").should == "/sites/new"
  end
  
  it "should map { :controller => 'sites', :action => 'show', :id => 1 } to /sites/1" do
    route_for(:controller => "sites", :action => "show", :id => 1).should == "/sites/1"
  end
  
  it "should map { :controller => 'sites', :action => 'edit', :id => 1 } to /sites/1/edit" do
    route_for(:controller => "sites", :action => "edit", :id => 1).should == "/sites/1/edit"
  end
  
  it "should map { :controller => 'sites', :action => 'update', :id => 1} to /sites/1" do
    route_for(:controller => "sites", :action => "update", :id => 1).should == "/sites/1"
  end
  
  it "should map { :controller => 'sites', :action => 'destroy', :id => 1} to /sites/1" do
    route_for(:controller => "sites", :action => "destroy", :id => 1).should == "/sites/1"
  end
  
end

describe "AuthenticatedAction", :shared => true do
  
  it "should authenticate user" do
    controller.should_receive(:current_user).at_least(:once).and_return(@user)
    do_action
  end
  
  it "should fail if no user is logged in" do
    controller.stub!(:current_user).and_return(:false)
    do_action
    response.should_not be_success
  end
end

describe "AuthorizedAction", :shared => true do

  it "should authorize user" do
    @site.should_receive(:authorize?).with(@user).and_return(true)
    do_action
  end

  it "should fail if the current user is not authorized" do
    @site.stub!(:authorize?).and_return(false)
    do_action
    response.should_not be_success
  end
end

describe SitesController, "handling GET /sites" do
  include SitesControllerSpecHelper
  it_should_behave_like "AuthenticatedAction"
  
  before do
    mock_sites_and_user
  end
  
  def do_get
    get :index
  end
  
  it "should be successful" do
    do_get
    response.should be_success
  end
  
  it "should render index template" do
    do_get
    response.should render_template('index')
  end
  
  it "should find all the users sites" do
    @user.should_receive(:find_sites).with(:all).and_return([@site])
    do_get
  end
  
  it "should assign the found sites for the view" do
    do_get
    assigns[:sites].should == [@site]
  end
end

describe SitesController, "handling GET /sites.xml" do
  include SitesControllerSpecHelper
  
  it_should_behave_like "AuthenticatedAction"
  
  before do
    mock_sites_and_user
    @site.stub!(:to_xml).and_return("XML")
  end
  
  def do_get
    @request.env["HTTP_ACCEPT"] = "application/xml"
    get :index
  end
  
  it "should be successful" do
    do_get
    response.should be_success
  end

  it "should find all user's sites" do
    @user.should_receive(:find_sites).with(:all).and_return([@site])
    do_get
  end
  
  it "should render the found sites as xml" do
    @sites.should_receive(:to_xml).and_return("XML")
    do_get
    response.body.should == "XML"
  end
end

describe SitesController, "handling GET /sites/1" do
  include SitesControllerSpecHelper
  
  it_should_behave_like "AuthenticatedAction"
  it_should_behave_like "AuthorizedAction"
  
  before do
    mock_sites_and_user
    Site.stub!(:find).and_return(@site)
  end
  
  def do_get
    get :show, :id => "1"
  end

  it "should be successful" do
    do_get
    response.should be_success
  end
  
  it "should render show template" do
    do_get
    response.should render_template('show')
  end
  
  
  it "should find the site requested" do
    Site.should_receive(:find).with("1").and_return(@site)
    do_get
  end
  
  it "should assign the found site for the view" do
    do_get
    assigns[:site].should equal(@site)
  end
  
end

describe SitesController, "handling GET /sites/1.xml" do
  include SitesControllerSpecHelper
  
  it_should_behave_like "AuthenticatedAction"
  it_should_behave_like "AuthorizedAction"
  
  before do
    mock_sites_and_user
    Site.stub!(:find).and_return(@site)
    @site.stub!(:to_xml).and_return("XML")
  end
  
  def do_get
    @request.env["HTTP_ACCEPT"] = "application/xml"
    get :show, :id => "1"
  end

  it "should be successful" do
    do_get
    response.should be_success
  end
  
  it "should find the site requested" do
    Site.should_receive(:find).with("1").and_return(@site)
    do_get
  end
  
  it "should render the found site as xml" do
    @site.should_receive(:to_xml).and_return("XML")
    do_get
    response.body.should == "XML"
  end
end

describe SitesController, "handling GET /sites/new" do
  include SitesControllerSpecHelper
  
  it_should_behave_like "AuthenticatedAction"
  
  before do
    mock_sites_and_user
    Site.stub!(:new).and_return(@site)
  end
  
  def do_get
    get :new
  end

  it "should be successful" do
    do_get
    response.should be_success
  end
  
  it "should render new template" do
    do_get
    response.should render_template('new')
  end
  
  it "should create an new site" do
    Site.should_receive(:new).and_return(@site)
    do_get
  end
  
  it "should not save the new site" do
    @site.should_not_receive(:save)
    do_get
  end
    
  it "should assign the new site for the view" do
    do_get
    assigns[:site].should equal(@site)
  end
  
end

describe SitesController, "handling GET /sites/1/edit" do
  include SitesControllerSpecHelper
  
  it_should_behave_like "AuthenticatedAction"
  it_should_behave_like "AuthorizedAction"
  
  before do
    mock_sites_and_user
    Site.stub!(:find).and_return(@site)
  end
  
  def do_get
    get :edit, :id => "1"
  end

  it "should be successful" do
    do_get
    response.should be_success
  end
  
  it "should render edit template" do
    do_get
    response.should render_template('edit')
  end
    
  it "should find the site requested" do
    Site.should_receive(:find).and_return(@site)
    do_get
  end
  
  it "should assign the found Site for the view" do
    do_get
    assigns[:site].should equal(@site)
  end
end

describe SitesController, "handling POST /sites" do
  include SitesControllerSpecHelper
  
  it_should_behave_like "AuthenticatedAction"
  
  before do
    mock_sites_and_user
    @site.stub!(:to_param).and_return("1")
    Site.stub!(:new).and_return(@site)
  end
  
  def do_post
    @site.stub!(:save).and_return(true)
    post :create, :site => {}
  end
  
  def post_with_successful_save
    @site.should_receive(:save).and_return(true)
    post :create, :site => {}
  end
   
  def post_with_failed_save
    @site.should_receive(:save).and_return(false)
    post :create, :site => {}
  end
  
  it "should create a new site" do
    Site.should_receive(:new).with({}).and_return(@site)
    post_with_successful_save
  end
  
  it "should link the site with the current user" do
    controller.stub!(:current_user).and_return(@user)
    Site.should_receive(:user=).with(@user)
    post_with_successful_save
  end

  it "should redirect to the new site on successful save" do
    post_with_successful_save
    response.should redirect_to(site_url("1"))
  end

  it "should re-render 'new' on failed save" do
    post_with_failed_save
    response.should render_template('new')
  end
end

describe SitesController, "handling PUT /sites/1" do
  include SitesControllerSpecHelper
  
  it_should_behave_like "AuthenticatedAction"
  it_should_behave_like "AuthorizedAction"
  
  before do
    mock_sites_and_user
    @site.stub!(:to_param).and_return("1")
    Site.stub!(:find).and_return(@site)
  end
  
  def do_put
    @site.stub!(:update_attributes).and_return(true)
    put :update, :id => "1"
  end
  
  def put_with_successful_update
    @site.should_receive(:update_attributes).and_return(true)
    put :update, :id => "1"
  end
  
  def put_with_failed_update
    @site.should_receive(:update_attributes).and_return(false)
    put :update, :id => "1"
  end
  
  it "should find the site requested" do
    Site.should_receive(:find).with("1").and_return(@site)
    put_with_successful_update
  end

  it "should update the found site" do
    put_with_successful_update
    assigns(:site).should equal(@site)
  end

  it "should assign the found site for the view" do
    put_with_successful_update
    assigns(:site).should equal(@site)
  end

  it "should redirect to the site on successful update" do
    put_with_successful_update
    response.should redirect_to(site_url("1"))
  end

  it "should re-render 'edit' on failed update" do
    put_with_failed_update
    response.should render_template('edit')
  end
end

describe SitesController, "handling DELETE /sites/1" do
  include SitesControllerSpecHelper
  
  it_should_behave_like "AuthenticatedAction"
  it_should_behave_like "AuthorizedAction"
  
  before do
    mock_sites_and_user
    @site.stub!(:destroy).and_return(true)
    Site.stub!(:find).and_return(@site)
  end
  
  def do_delete
    delete :destroy, :id => "1"
  end

  it "should find the site requested" do
    Site.should_receive(:find).with("1").and_return(@site)
    do_delete
  end
  
  it "should call destroy on the found site" do
    @site.should_receive(:destroy)
    do_delete
  end
  
  it "should redirect to the sites list" do
    do_delete
    response.should redirect_to(sites_url)
  end
end

