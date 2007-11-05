class Ping < ActiveRecord::Base
  belongs_to :site
  
  validates_presence_of :site, :response_time, :response_code, :response_text
  attr_immutable :response_time, :response_code, :response_text
  
end
