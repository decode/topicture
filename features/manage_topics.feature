Feature: Manage topics
  In order to operate topics
  As a user
  wants manage topics

  Scenario: Create new topic by unregistered user
    Given I goto the new topic page
    Then I should see "Login"

  Scenario: Create new topic by admin user
    Given I logged in as a admin user Ted
    And I am on the new topic page
    When I fill in "Name" with "name 1"
    And I fill in "Parent" with "1"
    And I fill in "Description" with "description 1"
    And I press "Create"
    Then I should see "name 1"

  Scenario: Delete topic
    Given I logged in as a admin user Ted
    And the following topics:
      |name|parent_id|description|
      |name 1|1|description 1|
      |name 2|2|description 2|
      |name 3|3|description 3|
      |name 4|4|description 4|
    When I am on topic manage page
    And I follow "Delete"
    Then I should not see "name 1"

  Scenario: Post message
    Given I logged in as a normal user Tex
    And I am on a topic page
    When I follow "Post"
    And I fill in "Title" with "post title 1"
    And I fill in "Body" with "post body 1"
    And I press "Create"
    Then I should see "post title 1"

  Scenario: Delete message
    Given I logged in as a admin user Ted
    And I am on the topic page included 2 messages
    When I follow "Delete"
    Then I should not see "message 1"
    And I should see "message 2"

  Scenario: View message
    Given I logged in as a normal user Tex
    And I am on topic page with message title "message"
    When I click the message title "message"
    Then I should see "message"
    And I should see "message body"
