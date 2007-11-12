Story: registered user logs in
  As a registered user
  I want to have to log in
  So that only other registered users can see my data

  Scenario: user logs in and sees user page
    Given a user registered with login: foo and password: test
    When user logs in with login: foo and password: test
    Then user should see the user page
