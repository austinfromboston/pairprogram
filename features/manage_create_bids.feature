Feature: Find a pair
  In order to Find a pair
  User
  wants to register

  Scenario: Register new user
    Given I am on the new search page
    And I fill in "Zip Code" with "90009"
    When I press "Find"

    Then I should see "No pairs"
    And I should see "Email me"
    And the "Zip" field should contain "90009"

    When I fill in "Email" with "foo@example.com"
    And I press "Do it"

    Then I should see "Sign in"
    And I prepare to auth via twitter
    And I follow "Twitter"
    Then I should see "Here's your listing"
    And I should see "Spice it up"

    When I press "Post it"
    Then I should see "We'll let you know"

  Scenario: Find existing bid
    Given these bids
      |email            |zip      |
      |bar@example.com  |11111    |
      |foo@example.com  |90009    |
    When I am on the new search page
    And I fill in "Zip Code" with "90009"
    And I press "Find"

    Then I should see "foo"
    And I should not see "bar"

    When I follow "Request Pair" within "[data-name='pair-with-foo']"

    Then I should see "Please email me"

    When I fill in "Email" with "pairprogram@gmail.com"
    And I press "Request Pair"

    Then I should see "Pairing request sent"

  Scenario: Add my bid when matches exist
    Given these bids
      |email            |zip      |
      |bar@example.com  |11111    |
      |foo@example.com  |90009    |
    When I am on the new search page
    And I fill in "Zip Code" with "90009"
    And I press "Find"

    Then I should see "add me to this list"
    When I follow "add me to this list"
    Then I should be on the new bid page

  Scenario: Review outstanding bids
    Given these bids
      |email            |zip      |
      |bar@example.com  |11111    |
      |foo@example.com  |90009    |
    And I am logged in as bar@example.com
    And I am on the dashboard page
    Then I should see "bar"
    Then I should see "Request Pair"

  Scenario: Returning user
    Given I am on the new search page
    When I follow "Sign in"
    Then I should be on the logins page

    When I am the returning user veteran@example.com
    And I prepare to auth via twitter
    And I follow "Twitter"
    Then I should be on the dashboard page
    And I should see "Sign out"

    When I follow "Sign out"
    Then I should be on the root page
    And I should see "Sign in"

  Scenario: Returning user with disabled account
    Given I am on the new search page
    When I follow "Sign in"
    Then I should be on the logins page

    When I am the disabled user spammer@example.com
    And I prepare to auth via twitter
    And I follow "Twitter"
    Then I should be on the root page
    And I should see "Your account has been disabled. Please post no further messages here."
    And I should see "Sign in"
