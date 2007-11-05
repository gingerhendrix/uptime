class Site < ActiveRecord::Base
  belongs_to :user
  
  validates_presence_of :url
  
  def authorize?(user)
    return user==self.user
  end
end
