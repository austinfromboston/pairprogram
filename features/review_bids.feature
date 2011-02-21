Feature: Review bids
  Person wants to review bids
  in order to find a pair

  Scenario: Reporting a spammy user
    Given these bids
      |email                  |zip      |
      |bar@example.com        |11111    |
      |foo@example.com        |90009    |
    When I am on the new search page
    And I fill in "Zip Code" with "90009"
    And I press "Find"

    When I follow "Report Abuse" within "[data-name='pair-with-foo']"
    And I select "Spam" from "abuse_report_reason"
    And I fill in "abuse_report_description" with "this is offensive tripe"
    And I press "Take That"

    Then I should see "Thank you"
    And I should see "I'll review your report shortly"
