Feature: Admin

  Scenario: Review flagged bids
    Given these flagged bids
      |email                  |zip      |
      |bar@example.com        |11111    |
      |foo@example.com        |90009    |
      |narf@example.com       |90009    |
    When I am the admin
    And I am on the new search page
    And I fill in "Zip Code" with "90009"
    And I press "Find"
    Then I should be on the bids page
    And I should see "foo"

    When I am on the flagged bids page
    Then I should see "foo"

    When I press "Disable User foo"
    Then I should be on the flagged bids page
    And I should see "That's the last we'll hear of foo"

    When I am on the new search page
    And I fill in "Zip Code" with "90009"
    And I press "Find"
    Then I should be on the bids page
    And I should not see "foo"
