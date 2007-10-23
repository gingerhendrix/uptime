require "net/http"

class HttpWorker < BackgrounDRb::Rails

  attr_accessor :text
  
  def do_work(args)
    results[:progress] = 0
    results[:status] = "Request Received"
    @text = args[:text]
    response = Net::HTTP.get_response('www.google.com', '/index.html')
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
