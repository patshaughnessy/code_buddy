require 'rubygems'
require 'bundler/setup'
require 'rspec/expectations'
require 'aruba/cucumber'

Before do
  @aruba_timeout_seconds = 120
end

