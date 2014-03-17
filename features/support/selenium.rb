if ENV['FORCE_SELENIUM']
  require 'capybara'

  ENV['NO_PROXY'] = '*'

  Capybara.default_driver    = :selenium
  Capybara.javascript_driver = :selenium
end