class Site < ActiveRecord::Base
  belongs_to :user
  
  validates_presence_of :url
end
