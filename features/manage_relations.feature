Feature: Manage relations
  In order to manage user relation
  as a normal user
  wants to manage friends

  Scenario: Request add friend
    Given I logged in as a normal user Jerry
    And I am on a page about user named Tom
    And I follow "Add as friend"
    When I send a friend invite request
    Then I should see "Your request has been sent"
    And user Tom should received a request from Jerry

  Scenario: Refuse other user's request
    Given I logged in as a normal user Jerry
    And I am on my request list page
    And the following list request:
      |title|body|sender|
      |hello|my friend|tom|
      |hi|there|aux|
    When I check the 1st request
    And I press "Refuse"
    Then I should see the request list:
      |title|body|sender|
      |hi|there|aux|
    And I should see the refuse list:
      |title|body|sender|
      |hello|my friend|tom|
