# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "code_buddy/version"

Gem::Specification.new do |s|
  s.name        = "code_buddy"
  s.version     = CodeBuddy::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Patrick Shaughnessy, Alex Rothenberg, Daniel Higginbotham']
  s.email       = ['pat@patshaughnessy.net, alex@alexrothenberg.com, daniel@flyingmachinestudios.com']
  s.homepage    = "http://github.com/patshaughnessy/code_buddy"
  s.summary     = %q{Write a gem summary}
  s.description = %q{Write a gem description}

  s.rubyforge_project = "code_buddy"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  
  s.add_dependency             'rack',          '~> 1.2.0'
  s.add_dependency             'sinatra',       '~> 1.1.0'
  s.add_dependency             'actionpack',    '~> 3.0.1'
  
  s.add_development_dependency 'rake',          '~> 0.8.7'
  s.add_development_dependency 'rspec',         '~> 2.1.0'

end
