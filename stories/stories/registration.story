Story: A user registers
	As a new user
	I want to register
	So that I can access the site
	
	Scenario: A new user signs up
		Given a new user
		When the user goes to the registration page
		Then the user should have to complete a registration form
		When the user submits the completed registration form
		Then the user should be able to log-in
		
  Scenario: A new user signs up with invalid registration data
		Given a new user
		When the user submits an invalid registration form
		Then the user should have to resubmit the form
		