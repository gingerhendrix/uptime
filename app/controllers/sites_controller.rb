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
    @site = Site.find(params[:id])

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
  end

  # POST /sites
  # POST /sites.xml
  def create
    @site = Site.new(params[:site])

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
    @site.destroy

    respond_to do |format|
      format.html { redirect_to sites_url }
      format.xml  { head :ok }
    end
  end
end
