Feature: Offer to pair
  In order to start pairing
  person 
  offers to pair

  Background:
    Given these bids
      |email                  |zip      |
      |bar@example.com        |11111    |
      |pairprogram@gmail.com  |90009    |

  Scenario: Happy pairing path
    When I am on the new search page
    And I fill in "Zip Code" with "90009"
    And I press "Find"

    When I follow "Request Pair" within "[data-name='pair-with-pairprogram']"
    And I fill in "Email" with "noob@example.com"
    And I press "Request Pair"

    Then "pairprogram" should receive an offer email from "noob"

    When I am logged in as noob@example.com
    And I am on the dashboard page
    Then I should see "pairprogram" within "[data-name='offer-to-pair-with-pairprogram']"

  @selenium
  Scenario: Signed in person
    When I am logged in as tester@example.com
    And I am on the new search page
    And I fill in "Zip Code" with "90009"
    And I press "Find"

    When I follow "Request Pair" within "[data-name='pair-with-pairprogram']"
    Then I should be on the bids page
    And I press "Request Pair" within "[data-name='pair-with-pairprogram']"
    Then "pairprogram" should receive an offer email from "tester"
