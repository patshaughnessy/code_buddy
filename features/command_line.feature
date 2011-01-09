Feature: Code Buddy command line execution

Scenario: Start code buddy with text from stdin
  Given I run "cat features/stack-trace | ./bin/code_buddy"
   When I run "curl http://localhost:9292/stack/0"
   Then I should see "blahblah"