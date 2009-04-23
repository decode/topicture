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
    And I am on manage gallary page
    When I follow "New Gallary"
    And I fill in "Name" with "mygallary"
    And I press "Create"
    Then I should see "mygallary"

  Scenario: Edit user's gallary
    Given I logged in as a normal user Jerry
    And the existing gallaries:
      |name|owner|
      |gallary|Jerry|
    And I am on manage gallary page
    When I follow "Edit"
    And I fill in "Name" with "newgallary"
    And I press "Update"
    Then I should see "newgallary"

  Scenario: Delete user's gallary
    Given I logged in as a normal user Jerry
    And the existing gallaries:
      |name|owner|
      |gallary|Jerry|
    And I am on manage gallary page
    When I follow "Delete"
    Then I should not see "gallary"

  Scenario: User set the gallary non-public
    Given I logged in as a normal user Jerry
    And the existing gallaries:
      |name|owner|
      |mygallary|Jerry|
    And I am on manage gallary page
    And I follow "Edit"
    When I check "ispublic"
    And I press "Update"
    And I am on gallary index page
    Then I should see "mygallary"

  Scenario: User set password for gallary
    Given I logged in as a normal user Jerry
    And the existing gallaries:
      |name|owner|
      |mygallary|Jerry|
    And I am on manage gallary page
    And I follow "Edit"
    When I fill in "password" with "password"
    And I check "ispublic"
    And I press "Update"
    And I am on gallary index page
    Then I should see "Password needed"

  Scenario: User access the password protected gallary
    Given I logged in as a normal user Fox
    And the existing gallaries:
      |name|owner|password|
      |mygallary|Jerry|pass|
    And I am on gallary index page
    When I follow "mygallary"
    Then I should see "Password Required"
