require File.dirname(__FILE__) + '/stories_helper'

require 'spec'
require 'spec/rails'

#require File.join(File.dirname(__FILE__), *%w[helper])

steps_for(:login) do
  Given("a user registered with login: $username and password: $password") do |username, password|
    user = User.new :login => username, 
                :password => password, 
                :password_confirmation => password,
                :email => 'test@example.com'
    user.save!
  end
  When("user logs in with login: $username and password: $password") do |username, password|
    post '/sessions', :login => username, :password => password
  end
  Then("user should see the user page") do
    response.should redirect_to('/sites')
  end
end

steps_for(:navigation) do
  
end

with_steps_for :login, :navigation do
  run File.dirname(__FILE__) + '/stories/login.story', :type => RailsStory
end
