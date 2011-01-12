$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rspec'
require 'mocha'

module Rails
  class MockEnvironment
    def development?
      true
    end
  end
  class << self
    def env
      MockEnvironment.new
    end
  end
  class Railtie
    def self.initializer(name); end
  end
  class VERSION
    MAJOR = 3
  end
end
module ActionDispatch
  class ShowExceptions
    def call(env); end
  end
end

def silence_warnings; end

require 'code_buddy'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[File.join(File.dirname(__FILE__), "spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  config.mock_with :mocha
end
