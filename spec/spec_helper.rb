ENV['RACK_ENV'] ||= 'test'

require 'rspec/its'
require 'capybara'

require_relative 'dummy/app'

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = %i(should expect)
  end

  config.run_all_when_everything_filtered = true
  config.filter_run :focus

  config.order = 'random'

  config.include Capybara::DSL
end

Capybara.app = DummyApp
