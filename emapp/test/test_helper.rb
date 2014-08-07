ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require "minitest/reporters"
require "minitest/spec"
Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all
  extend MiniTest::Spec::DSL
  class << self
    remove_method :describe
  end
  register_spec_type self do |desc|
    desc < ActiveRecord::Base if desc.is_a? Class
  end

  # Add more helper methods to be used by all tests here...
end
