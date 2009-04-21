Feature:
  In order to manage gallary
  as a normal user
  wants to control the gallary accassibility

  Scenario: View a normal gallary
    Given I am on gallary index page
    And the existing gallaries:
      |name|owner|
      |gallary|Jerry|
    When I follow "gallary"
    Then I should see "Attachments"

  Scenario: Create new gallary
    Given I logged in as a normal user Jerry
    And I am on create gallary page
    When I fill "Name" with "mygallary"
    And I press "Create"
    Then I should see "mygallary"

