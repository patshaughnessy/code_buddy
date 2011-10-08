Given /^I have created a new Rails 3 app "([^"]*)" with code_buddy$/ do |app_name|
  steps <<-STEPS
    Given I run "bundle install --gemfile=../../features/support/Gemfile-rails3"
    And I successfully run "rails new #{app_name}"
    And I cd to "#{app_name}"
    And I append to "Gemfile" with:
      """
      gem 'rspec'
      # gem 'akephalos', :git => 'https://github.com/thoughtbot/akephalos.git'
      gem "cucumber-rails"
      gem "capybara",  '~> 0.3.8'
      gem 'code_buddy', :path=>File.expand_path("../../../..", __FILE__)
      """
    And I run "bundle install"
    And I run "rails generate cucumber:install"
    And I replace "# Add more mappings here." in "features/support/paths.rb" with:
      """
      when "code_buddy"
        "/code_buddy/stack/0"
      """
    And I run "rake db:migrate"
  STEPS
end

Given /^I have created a new Rails 2 app "([^"]*)" with code_buddy$/ do |app_name|
  steps <<-STEPS
    Given I run "bundle install --gemfile=../../features/support/Gemfile-rails2"
    And I successfully run "rails _2.3.10_ #{app_name}"
    And I cd to "#{app_name}"
    And I replace "# Specify gems that this application depends on and have them installed with rake gems:install" in "config/environment.rb" with:
      """
      # Specify gems that this application depends on and have them installed with rake gems:install
      config.gem 'code_buddy' 
      config.middleware.use "CodeBuddy::ShowApp"
      """
    And I run "mkdir vendor/gems"
    And I run "ln -s #{File.expand_path("../../..", __FILE__)} vendor/gems/code_buddy-#{CodeBuddy::VERSION}"
    And I run "rake environment ; script/generate cucumber --capybara"
    And I replace "# Add more mappings here." in "features/support/paths.rb" with:
      """
      when "code_buddy"
        "/code_buddy/stack/0"
      """
    And I run "rake db:migrate"
  STEPS
end


Given /^I have created a test harness "([^"]*)" for sinatra$/ do |app_name|
  steps <<-STEPS
    Given I run "gem install cucumber-sinatra"
    And I successfully run "mkdir #{app_name}"
    And I cd to "#{app_name}"
    And I run "cucumber-sinatra init CodeBuddy::App ../../../spec/spec_helper.rb"
  STEPS
  # And I run "cp #{File.expand_path("../templates/sinatra_env.rb.template", __FILE__)} features/support/env.rb"
end

Given /^I enable show_exceptions in "([^"]*)"$/ do |file_name|
  # Given %Q[I replace "config.action_dispatch.show_exceptions = false" in "#{file_name}"], pystring #Cucumber::Ast::PyString.parse('config.action_dispatch.show_exceptions = true')
  cmd = "sed s/'config.action_dispatch.show_exceptions = false'/'config.action_dispatch.show_exceptions = true'/ #{file_name}"
  run_simple(cmd)
  _create_file(file_name, stdout_from(cmd), true)
end

Given /^I replace "([^"]*)" in "([^"]*)" with:$/ do |marker, file_name, new_text|
  file = File.readlines(File.join(current_dir, file_name))
  new_content = file.map do |line|
    if line =~ Regexp.new(marker)
      new_text
    else
      line
    end
  end
  _create_file(file_name, new_content, true)
end


