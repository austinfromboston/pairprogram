Feature: Admin

  Scenario: Review abuse reports
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

    When I am on the abuse reports page
    Then I should see "foo"

    When I press "Disable User foo"
    Then I should be on the abuse reports page
    And I should see "That's the last we'll hear of foo"

    When I am on the new search page
    And I fill in "Zip Code" with "90009"
    And I press "Find"
    Then I should be on the bids page
    And I should not see "foo"
