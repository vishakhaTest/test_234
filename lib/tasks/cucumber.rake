require_relative 'safe_load'

safe_load('cucumber') do
  require 'cucumber/rake/task'

  namespace :cucumber do
    Cucumber::Rake::Task.new(:default) do |t|
      t.cucumber_opts = "features --format pretty"
    end
  end

  task :cucumber => 'cucumber:default'
end