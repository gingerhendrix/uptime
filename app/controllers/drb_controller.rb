class DrbController < ApplicationController

  def index
  end
 
  def start
    if request.xhr?
      @remote_url  = params[:task][:url]
      session[:job_key] = 
        ::MiddleMan.new_worker(:class => :http_worker,
                               :args => {:text => 'this text has been sent to the worker.', :remote_url => @remote_url })
      render :update do |page|
        page.replace_html 'form', :partial => 'poll'
      end  
    end  
  end

  def ping
    if request.xhr?
      results = ::MiddleMan.worker(session[:job_key]).results.to_hash
      render :update do |page|
        page.call('progressPercent', 'progressbar', results[:progress])
        page.call('statusUpdate',  results[:status])     
        page.redirect_to( :action => 'done')   if results[:progress] >= 100
      end
    else
      redirect_to :action => 'index'   
    end
  end

  def done
    worker = MiddleMan.worker(session[:job_key])
    results = worker.results.to_hash
    response = results[:response]
    @response_obj = response
    @response_status = response.code
    @status = results[:status]
   worker.delete
  end 

end
