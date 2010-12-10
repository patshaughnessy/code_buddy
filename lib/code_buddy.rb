require 'sinatra'
require 'coderay'
require 'json'
require 'json/add/rails'

require 'code_buddy/app'
require 'code_buddy/stack'
require 'code_buddy/stack_frame'
require 'code_buddy/middleware'

def rails_version
  Rails::VERSION::MAJOR
rescue NameError
  nil
end

case rails_version
when 2:
  require 'code_buddy/rails2/monkey_patch_action_controller'
when 3:
  require 'code_buddy/rails3/railtie.rb'
end
