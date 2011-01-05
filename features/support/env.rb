require 'rubygems'
require 'bundler/setup'
require 'rspec/expectations'
require 'aruba/cucumber'

Before do
  unset_bundler_env_vars
end

