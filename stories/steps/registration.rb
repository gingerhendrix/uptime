steps_for(:registration) do
  Given("a new user") do
    #Do nothing
    
  end
  
  When("the user goes to the registration page") do
    get "/users/new"
  end
  
  When("the user submits the completed registration form") do
    post "/users", RegistrationFactory.instance.registration_form
  end
  
  When("the user submits an invalid registration form") do
    post "/users", RegistrationFactory.instance.registration_form({:password_confirmation => "blah"})
  end
  
  Then("the user should have to complete a registration form") do
    response.should be_success
    response.should have_tag("form[action='/users']")
  end
  
  Then("the user should have to resubmit the form") do
    response.should have_tag("form[action='/users']")
  end
  
  Then("the user should be able to log-in") do
    form = RegistrationFactory.instance.registration_form
    post "/sessions", {:login => form['login'], :password => form['password']}
    response.should be_success
  end
  
end