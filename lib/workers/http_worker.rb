require "net/http"

class HttpWorker < BackgrounDRb::Rails

  attr_accessor :text
  attr_accessor :remote_url
  
  def do_work(args)
    results[:progress] = 0
    results[:status] = "Request Received"
    @remote_url = URI.parse(args[:remote_url]);
    response = Net::HTTP.get_response(@remote_url)
    results[:progress] = 100
    results[:response] = response
    results[:response_status] = response.code
    results[:status] = "Request Complete"
  end

  def progress
    results[:progress]
  end
end

HttpWorker.register
