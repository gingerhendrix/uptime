steps_for(:login) do
  

  Given("a user registered with login: $username and password: $password") do |username, password|
    User.destroy_all #I shouldn't need this but transactions aren't working smoothly out of the box
    user = User.new :login => username, 
                :password => password, 
                :password_confirmation => password,
                :email => 'test@example.com'
    user.save!
  end
  
  Given("a logged-in, registered user") do
    User.destroy_all #I shouldn't need this but transactions aren't working smoothly out of the box
    user = User.new :login => "test", 
                :password => "password", 
                :password_confirmation => "password",
                :email => 'test@example.com'
    user.save!
    post '/sessions', :login => "test", :password => "password"
  end
  
  When("user logs in with login: $username and password: $password") do |username, password|
    post '/sessions', :login => username, :password => password
  end
  Then("user should see the user page") do
    response.should redirect_to('/sites')
  end
end