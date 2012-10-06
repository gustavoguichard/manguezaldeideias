Feature: View an idea
  In order to discover an idea's content
  As a visitor
  I want to view an idea

  Scenario: View an idea
    Given there is an idea called "My idea lol" that belongs to "TISA"
    When I visit the "My idea lol" idea page
    Then I should see the title as "My idea lol · Manguezal de Ideias"

  Scenario: View a ramified idea
    Given there is an user called "Paul McCartney"
    And there is an idea called "A Day in the Life" by "John Lennon"
    And "Paul McCartney" ramified the idea "A Day in the Life"
    When I visit the "A Day in the Life" by "Paul McCartney" idea page
    Then I should see "Criada a partir da ideia A Day in the Life, de John Lennon"
