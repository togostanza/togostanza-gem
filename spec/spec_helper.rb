ENV['RACK_ENV'] ||= 'test'

require_relative 'dummy/server'
require 'capybara'

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus

  config.order = 'random'

  config.include Capybara::DSL
end

Capybara.app = DummyServer
