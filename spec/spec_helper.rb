require 'rspec'
require 'simplecov'
require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start
SimpleCov.start do
  add_filter '/spec/'
end
