Feature: Status
  In order to know the condition of the site
  As a customer or admin
  I want to be able to see or manage site's status
  Scenario: Display current status
    Given I have 20 existing status updates
    When I show current status
    Then I should see the current status update
    Then I should see the 10 most recent status updates
