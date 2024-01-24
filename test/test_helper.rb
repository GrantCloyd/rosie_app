# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require 'minitest/rails'
require 'mocha/minitest'

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    # commented out due to causing visual errors when using binding.pry in test environments
    #  parallelize(workers: :number_of_processors)

    # Add more helper methods to be used by all tests here...
    include FactoryBot::Syntax::Methods
  end
end
