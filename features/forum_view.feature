Feature: View style of forum
  In order to display like forum
  as a normal user
  wants to see

  Scenario: View forum' first page
    Given I logged in as a guest user guest
    When I goto the forum first page
    Then I should see "Topic"

  Scenario: View post in forum page
    Given I logged in as a guest user guest
    And I am on a topic page named Computer
    When I follow a topic titled newpc
    Then I should see "Reply"
    And I should see "newpc"

  Scenario: User edit his own post
    Given I logged in as a normal user Jerry
    And the existing post list:
      |topic|title|body|poster|
      |Computer|Post|body|Jerry|
    And I am on a post thread named Post
    When I follow "Edit"
    And I fill in "Title" with "new title"
    And I fill in "Body" with "new body"
    And I press "Update"
    Then I should see "new title"

  Scenario: Anonymous can not reply a post
    Given I am on a topic page named Computer
    And I follow a topic titled newpc
    When I press "Post"
    Then I should see "Login"

  Scenario: User follow a post
    Given I logged in as a normal user Jerry
    And I am on a topic page named Computer
    When I follow a topic titled new pc
    And I fill in "message_title" with "reply"
    And I fill in "message_body" with "reply body"
    And I press "Post"
    Then I should see "Message was successfully created"

  Scenario: User modify a exist post reply
    Given I logged in as a normal user Jerry
    And I am on a topic page named Computer
    And I reply a post titled myPost
    When I follow "Edit"
    And I fill in "Title" with "new"
    And I fill in "Body" with "changed body"
    And I press "Update"
    Then I should see "new"
    And I should see "changed body"

  Scenario: User quote the post of another user
    Given I logged in as a normal user Jerry
    And the existing post list:
      |topic|title|body|poster|
      |Computer|Post|body|Jerry|
    And I am on a post thread named Post
    And I follow "Quote"
    Then I should see "Quote content:"

  Scenario: User reply a user in current post thread
    Given I logged in as a normal user Jerry
    And the existing post list:
      |topic|title|body|poster|
      |Computer|Post|body|Jerry|
    And I am on a post thread named Post
    When I follow "Reply"
    Then I should see "reply Jerry post"
