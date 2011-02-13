Feature: Offer to pair
  In order to start pairing
  person 
  offers to pair

  Scenario: Happy pairing path
    Given these bids
      |email                  |zip      |
      |bar@example.com        |11111    |
      |pairprogram@gmail.com  |90009    |
    When I am on the new search page
    And I fill in "Zip Code" with "90009"
    And I press "Find"

    When I follow "Request Pair" within "[data-name='pair-with-pairprogram']"
    When I fill in "Email" with "noob@example.com"
    And I press "Request Pair"

    Then "pairprogram" should receive an offer email from "noob"
