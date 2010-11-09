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

    Then I should see "We'll let you know"

  Scenario: Find existing bid
    Given these bids
      |email            |zip      |
      |bar@example.com  |11111    | 
      |foo@example.com  |90009    | 
    When I am on the new search page
    And I fill in "Zip Code" with "90009"
    And I press "Find"

    Then I should see "foo@example.com"
    And I should not see "bar@example.com"

    When I follow "Request Pair" within "[data-name='pair-with-foo@example.com']"

    Then I should see "Please email me"

    When I fill in "Email" with "noob@example.com"
    And I press "Request Pair"

    Then I should see "Pairing Request Sent"

  @wip
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
  # Rails generates Delete links that use Javascript to pop up a confirmation
  # dialog and then do a HTTP POST request (emulated DELETE request).
  #
  # Capybara must use Culerity/Celerity or Selenium2 (webdriver) when pages rely
  # on Javascript events. Only Culerity/Celerity supports clicking on confirmation
  # dialogs.
  #
  # Since Culerity/Celerity and Selenium2 has some overhead, Cucumber-Rails will
  # detect the presence of Javascript behind Delete links and issue a DELETE request 
  # instead of a GET request.
  #
  # You can turn this emulation off by tagging your scenario with @no-js-emulation.
  # Turning on browser testing with @selenium, @culerity, @celerity or @javascript
  # will also turn off the emulation. (See the Capybara documentation for 
  # details about those tags). If any of the browser tags are present, Cucumber-Rails
  # will also turn off transactions and clean the database with DatabaseCleaner 
  # after the scenario has finished. This is to prevent data from leaking into 
  # the next scenario.
  #
  # Another way to avoid Cucumber-Rails' javascript emulation without using any
  # of the tags above is to modify your views to use <button> instead. You can
  # see how in http://github.com/jnicklas/capybara/issues#issue/12
  #
