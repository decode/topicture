Feature: View style of blog
  In order to display like blog
  as a normal user
  wants to see

  Scenario: View user's first page
    Given I logged in as a guest user guest
    And I am on a page about user named Ben
    When I use blog view
    Then I should see "Login"
    And I should see "Register"

