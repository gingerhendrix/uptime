class SitesController < ApplicationController
  before_filter :login_required
  
  # GET /sites
  # GET /sites.xml
  def index
    @user = self.current_user
    @sites = @user.find_sites(:all)

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @sites.to_xml }
    end
  end

  # GET /sites/1
  # GET /sites/1.xml
  def show
    @site = Site.find(params[:id], :include=>[:pings])
    
    return if !self.authorize?
    
    respond_to do |format|
        format.html # show.rhtml
        format.xml  { render :xml => @site.to_xml }
    end
  end

  # GET /sites/new
  def new
    @site = Site.new
  end

  # GET /sites/1;edit
  def edit
    @site = Site.find(params[:id])
    return if !self.authorize?
  end

  # POST /sites
  # POST /sites.xml
  def create
    @site = Site.new(params[:site])
    @site.user = self.current_user    
    
    respond_to do |format|
      if @site.save
        flash[:notice] = 'Site was successfully created.'
        format.html { redirect_to site_url(@site) }
        format.xml  { head :created, :location => site_url(@site) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @site.errors.to_xml }
      end
    end
  end

  # PUT /sites/1
  # PUT /sites/1.xml
  def update
    @site = Site.find(params[:id])
    
    return if !self.authorize?
    
    respond_to do |format|
      if @site.update_attributes(params[:site])
        flash[:notice] = 'Site was successfully updated.'
        format.html { redirect_to site_url(@site) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @site.errors.to_xml }
      end
    end
  end

  # DELETE /sites/1
  # DELETE /sites/1.xml
  def destroy
    @site = Site.find(params[:id])
    
    return if !self.authorize?
    
    @site.destroy
    
    respond_to do |format|
      format.html { redirect_to sites_url }
      format.xml  { head :ok }
    end
  end
  
  # POST /sites/1/ping
  # POST /sites/1/ping.xml
  def ping
    @site = Site.find(params[:id])
    return if !self.authorize?
    
    session[:job_key] = 
        ::MiddleMan.new_worker(:class => :ping_worker,
                               :args => {:site_id => params[:id]})
    
    # @site.ping!
    if request.xhr?
      respond_to do |format|
        format.html { redirect_to sites_url }
        format.xml  { head :ok }
      end
    else
      respond_to do |format|
        format.html do      
          render :update do |page|
              page.replace_html 'form', :partial => 'poll'
          end
        end
        format.xml  { head :ok }
      end
    end
    
  end
  
  def ping_poll
    job_key = session[:job_key]
    puts "Key" + job_key
    worker = ::MiddleMan.worker(job_key)
    puts "Worker" + worker
    @results = worker.results.to_hash
    
    render :update do |page|
        page.call('statusUpdate',  results[:status])     
    end
  end
  
  protected
  
  def authorize?
    if ! @site.authorize?(self.current_user)
      render :text => "You are not authorized to access thise resource", :status => :forbidden
      return false
    end
    return true
  end
end
