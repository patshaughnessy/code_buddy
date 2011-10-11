Feature: Make sure CodeBuddy works with a Rails3 app

@disable-bundler
@announce @create-code_buddy_rails3_test-gemset
Scenario: See a stack trace with links
  Given I'm using a clean gemset "code_buddy_rails3_test"
    And I have created a new Rails 3 app "new_rails3_app" with code_buddy 
    And I run "rails generate scaffold users"
    And I overwrite "app/views/users/index.html.erb" with:
      """
      <%= raise 'oops' %>
      """
    And I run "rake db:migrate"
    And I enable show_exceptions in "config/environments/test.rb"
    And I run "cp ../../../features/templates/rails_exception.feature.template features/rails_exception.feature"
    And I run "bundle exec rake cucumber -v"
    Then it should pass with:
       """
       1 scenario (1 passed)
       4 steps (4 passed)
       """
      
      
