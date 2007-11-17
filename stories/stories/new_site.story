Story: A user adds a new site
	As a user
	I want to add a new site
	So that I can ping the site

	Scenario:  user creates a new site
		Given a logged-in, registered user
		When the user goes to new site page
		Then the user sees a form for creating a new site
		When the user submits form with url: http://www.gandrew.com
		Then a new site is created with url: http://www.gandrew.com
		And the user sees the site page with url: http://www.gandrew.com
	