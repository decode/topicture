Feature: Manage relations
  In order to manage user relation
  as a normal user
  wants to manage friends

  Scenario: Request add friend
    Given I logged in as a normal user Jerry
    And I am on a page about user named Tom
    And I follow "Add as friend"
    When I send a friend invite request
    Then I should see "Your request has been send"
    And user Tom should received a request from Jerry
