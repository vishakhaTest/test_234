require 'capybara/cucumber'
require 'capybara/poltergeist'
require 'rspec/expectations'

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, {timeout: 100, js_errors: true})
end

Capybara.javascript_driver = :poltergeist
Capybara.default_wait_time = 100

World(Rack::Test::Methods)
