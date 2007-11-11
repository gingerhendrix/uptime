class Site < ActiveRecord::Base
  belongs_to :user
  has_many :pings
  
  validates_presence_of :url
  
  def authorize?(user)
    return user==self.user
  end
  
  def ping!
    ping = self.build_ping
    time = Time.now
    response = Net::HTTP.get_response(URI.parse(self.url))
    ping.response_time = Time.now - time
    ping.response_code = response.code
    ping.response_text = response.message
    ping.save!
    return ping
  end
end
