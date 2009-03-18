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
    When I check the 1st request on friend page
    And I press "Refuse"
    Then I should see the user request list:
      |sender|title|body|
      |aux|hi|there|

  Scenario: Accept other user's request
    Given I logged in as a normal user Jerry
    And I am on my request list page
    And the following list request:
      |title|body|sender|
      |hello|my friend|tom|
      |hi|there|aux|
    When I check the 1st request on friend page
    And I press "Accept"
    And I goto my friend list page
    Then I should see "tom"

  Scenario: Delete friend
    Given I logged in as a normal user Jerry
    And I am on my request list page
    And the following list friends:
      |friend|
      |ender|
    When I check the 1st friend on friend page 
    And I press "Delete"
    And I goto my friend list page
    Then I should not see "ender"

  Scenario: Block friend
    Given I logged in as a normal user Jerry
    And I am on my request list page
    And the following list friends:
      |friend|
      |tom|
      |aux|
    When I check the 1st friend on friend page
    And I press "Block"
    And I goto my friend list page
    Then I should not see "tom"
