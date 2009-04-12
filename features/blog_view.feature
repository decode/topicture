Feature: View style of blog
  In order to display like blog
  as a normal user
  wants to see

  Scenario: View user's first page
    Given I logged in as a guest user guest
    And I am on a page about user named Ben
    When I am on the articles list page
    Then I should see "New Post"
    And I should see "New users"

  Scenario: Post new article
    Given I logged in as a normal user Jerry
    And I am on the new article page
    When I fill in "Title" with "title 1"
    And I fill in "Body" with "body 1"
    And I press "Create"
    Then I should see "title 1"
    And I should see "body 1"
    And I should see "1"

  Scenario: Edit article 
    Given I logged in as a normal user Jerry
    And the existing articles:
      |title|body|author|
      |title 1|body 1|Jerry|
    When I am on the article manage page
    And I follow "Edit"
    And I fill in "Title" with "new title 1"
    And I fill in "Body" with "new body 1"
    And I press "Update"
    Then I should see "new title 1"
    And I should see "new body 1"

  Scenario: Delete article
    Given I logged in as a normal user Jerry
    And the existing articles:
      |title|body|author|
      |title 1|body 1|Jerry|
      |title 2|body 2|Jerry|
      |title 3|body 3|Jerry|
      |title 4|body 4|Jerry|
    When I am on the article manage page 
    And I follow "Delete"
    Then I should not see "title 4"
  
  Scenario: Comment a article
    Given I logged in as a normal user Jerry
    And the existing articles:
      |title|body|author|
      |target title 1|body 1|Aux|
    When I view the article
    And I fill in "message_title" with "title 2"
    And I fill in "message_body" with "body 2"
    And I press "Post"
    Then I should see "target title 1"
    And I should see "title 2"
    And I should see "body 2"

