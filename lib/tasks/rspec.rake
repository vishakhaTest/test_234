require_relative 'safe_load'

safe_load('spec') do
  # rspec
  require 'rspec/core/rake_task'

  RSpec::Core::RakeTask.new(:spec)
end