Feature: Manage messages
  In order to manage messages
  as a normal user 
  wants to operator the message
  
  Scenario: Register new message
    Given I logged in as a normal user Jerry
    And I am on the new message page
    When I fill in "Title" with "title 1"
    And I fill in "Body" with "body 1"
    And I press "Create"
    Then I should see "title 1"
    And I should see "body 1"
    And I should see "1"

  Scenario: Edit message
    Given I am the normal user
    And the existing messages:
      |title|body|
      |title 1|body 1|
    When I change the message:
      |title|body|
      |new title 1|new body 1|
    And I press "Update"
    Then I should see "new title 1"
    And I should see "new body 1"

  Scenario: Delete message
    Given I am the admin user
    And the following messages:
      |title|body|
      |title 1|body 1|
      |title 2|body 2|
      |title 3|body 3|
      |title 4|body 4|
    When I delete the 3rd message
    Then I should see the following messages:
      |title|body|
      |title 1|body 1|
      |title 2|body 2|
      |title 4|body 4|
  
  Scenario: Reply message
    Given I am the normal user
    And the posted messages:
      |title|body|
      |target title 1|body 1|
    When I reply the message with new message
    And I fill in "Title" with "title 2"
    And I fill in "Body" with "body 2"
    And I press "Create"
    Then I should see "target title 1"
    And I should see "title 2"
    And I should see "body 2"
