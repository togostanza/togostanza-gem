ENV['RACK_ENV'] ||= 'test'

require 'rspec/its'
require 'capybara/rspec'

require_relative 'dummy/app'

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = %i(should expect)
  end

  config.run_all_when_everything_filtered = true
  config.filter_run :focus

  config.order = 'random'
end

Capybara.app = DummyApp
