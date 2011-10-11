Feature: Make sure CodeBuddy works with a Rails 2 app

@disable-bundler
@announce @create-code_buddy_rails2_test-gemset
Scenario: See a stack trace with links
  Given I'm using a clean gemset "code_buddy_rails2_test"
    And I have created a new Rails 2 app "new_rails2_app" with code_buddy 
    And I run "script/generate scaffold user"
    And I overwrite "app/views/users/index.html.erb" with:
      """
      <%= raise 'oops' %>
      """
    And I run "rake db:migrate"
    And I run "cp ../../../features/templates/rails_exception.feature.template features/rails_exception.feature"
    And I run "rake cucumber"
    Then it should pass with:
       """
       1 scenario (1 passed)
       4 steps (4 passed)
       """
      
      
