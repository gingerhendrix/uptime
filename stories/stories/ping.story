Story: A user pings a site
	As a user
	I want to be able to ping my sites
	So that I can see if they are responding
	
	Scenario: user pings a site
		Given a logged-in, registered user, with a site
		When the user visits a site page
		The user sees a button for pinging the site
		When the user pings the site
		Then the site is pinged
		And the user sees a page with the response from the ping