Feature: Make sure CodeBuddy works when started as a sinatra app

@announce
Scenario: See a stack trace with links
  Given I have created a test harness "sinatra_testing" for sinatra
    And I run "cp ../../../features/templates/sinatra_homepage.feature.template features/sinatra_homepage.feature"
    And I run "cp ../../../features/templates/sinatra_paths.rb.template features/support/paths.rb"
    And I run "cucumber ."
    Then it should pass with:
    """
    1 scenario (1 passed)
    2 steps (2 passed)
    """
      
      
