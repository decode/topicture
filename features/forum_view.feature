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
    And I am on a topic page named "Computer"
    When I follow a topic titled "new pc"
    Then I should see "Reply"
    And I should see "new pc"

  Scenario: Anonymous can not reply a post
    Given I am on a topic page named "Computer"
    And I follow a topic titled "new pc"
    When I press "Post"
    Then I should see "Login"

  Scenario: User follow a post
    Given I logged in as a normal user Jerry
    And I am on a topic page named "Computer"
    When I follow a topic titled "new pc"
    And I fill in "Title" with "reply"
    And I fill in "Body" with "reply body"
    And I press "Post"
    Then I should see "reply body"
