require "net/http"

class PingWorker < BackgrounDRb::Rails
  attr_accessor :site_id
  
  def do_work(args)
    results[:progress] = :started
    @site = Site.find(@site_id)
    ping = @site.ping!
    results[:ping_id] = ping.id
    results[:progress] = :finished
  end

  def progress
    results[:progress]
  end
  
end


PingWorker.register