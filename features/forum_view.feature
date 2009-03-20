Feature: View style of forum
  In order to display like forum
  as a normal user
  wants to see

  Scenario: View forum' first page
    Given I logged in as a guest user guest
    When I goto the forum first page
    Then I should see "Topic"
