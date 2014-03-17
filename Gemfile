source 'http://rubygems.org'

ruby '2.0.0'

gem 'sinatra'
gem 'sinatra-contrib'

gem 'rake'
gem 'dotenv'
gem 'git'

gem 'app-version', git: 'git@github.com:VodafoneAustralia/app-version-gem.git'
gem 'app-logging', git: 'git@github.com:VodafoneAustralia/app-logging-gem.git'

group :development, :test do
  gem 'bundler'
  gem 'shotgun'
  gem 'rspec'
  gem 'capybara'
  gem 'rack-test'
  gem 'cucumber'
  gem 'poltergeist'
  gem 'selenium-webdriver'

  gem 'pry'
  gem 'pry-nav'
  gem 'pry-stack_explorer'

  gem 'halidator'

  gem 'simplecov'
  gem 'simplecov-rcov'

  gem 'jmeter-runner-gem', :git => 'git@github.com:VodafoneAustralia/jmeter-runner-gem.git', require: false
  gem 'ruby-jmeter', require: false

  gem 'jenkins_api_client', :git => 'git@github.com:VodafoneAustralia/jenkins_api_client.git'
  gem 'jenkins-branching', :git => 'git@github.com:VodafoneAustralia/jenkins-branching.git'
end

group :qa, :production do
  gem 'unicorn'
end