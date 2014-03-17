require 'dotenv'
require 'app-version'

Dotenv.load('.env.test', '.env')

Dir.glob('lib/tasks/*.rake').each { |file| load file }

task :default => [:spec, :cucumber, 'version:create']