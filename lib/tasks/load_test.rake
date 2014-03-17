namespace :load_test do
  begin
    require 'ruby-jmeter'
    require 'jmeter-runner-gem'
    Dir["/lib/load_test/*.rb"].each {|file| require file }

    desc "Runs the load test locally against the given environment, set the HOST env variable to run against a different environment i.e. HOST=search-app.load-test.np.syd.services.vodafone.com.au"
    task :run => [:environment, :purge_artifacts] do

      check_for_and_install_jmeter unless ENV['JMETER_PATH']

      if ENV['HOST']
        puts "Running load test against #{ENV['HOST']}"
        run_test
      else
        puts "Running load test against local unicorn instance"
        using_a_local_unicorn do
          run_test
        end
      end

    end

    desc "Runs the load test using flood.io, Set FLOOD_IO_KEY env variable to override flood.io api key"
    task :flood => [:allow_net_connect, :environment] do
      abort "Aborting load test: you must set a flood.io api key to use Flood.io" unless ENV['FLOOD_IO_KEY']
      load_test.grid ENV['FLOOD_IO_KEY']
    end

    desc 'Output a jmx representation of the test that can be opened and executed manually in jmeter'
    task :jmx => :environment do
      load_test.jmx(file: "tmp/#{running_test}.jmx")
    end

    # FIXME this is a hack to work around WebMock's local pollution which blocks access to flood.io
    task :allow_net_connect do
      WebMock.allow_net_connect!
    end

    task :purge_artifacts do
      FileUtils.rm Dir.glob("tmp/#{running_test}.jtl")
    end
  rescue LoadError
    desc 'load_test rake task not available (jmeter gem not installed)'
    task :load_test do
      abort 'load_test rake task is not available. Be sure to install jmeter gem'
    end
  end

private

  def load_test
    puts "Finding load test: #{running_test}"
    test_dsl = "LoadTest::#{running_test.to_s.camelize}".constantize.new(
      host: ENV['HOST'],
      duration: ENV['DURATION'],
      thread_count: ENV['THREAD_COUNT'])
    test_dsl.plan
  end

  def running_test
    ENV['TEST'] || :search_with_random_query
  end

  def run_test
    load_test.run jtl: "tmp/#{running_test}.jtl",
      path: jmeter_path,
      properties: 'config/load_test/jmeter.properties'
  end

  def jmeter_path
    ENV['JMETER_PATH'] || 'build/apache-jmeter-*/bin/'
  end

  def check_for_and_install_jmeter
    # a bit dodge, but uses the JmeterRunnerGem to install jmeter if it's not present
    jmeter_runner = JmeterRunnerGem::Test.new nil, nil, nil, nil, nil, nil
    jmeter_runner.install_jmeter unless jmeter_runner.is_jmeter_installed?
    jmeter_runner.install_jmeter_standard_plugin unless jmeter_runner.is_jmeter_standard_plugin_installed?
    jmeter_runner.install_jmeter_extras_plugin unless jmeter_runner.is_jmeter_extras_plugin_installed?
  end

  def using_a_local_unicorn
    begin
      config = Rails.root.join "config/load_test/unicorn.rb"
      puts "Starting unicorn with #{config}"
      FileUtils.mkdir_p 'tmp/pids'
      sh "bundle exec unicorn --daemonize --config-file '#{config}' -p 3000"
      yield if block_given?
    ensure
      Process.kill :QUIT, unicorn_pid
    end
  end

  def unicorn_pid
    pid_file = Rails.root.join "tmp/pids/unicorn.pid"
    begin
      pid_file = "/tmp/unicorn.pid" unless File.exists? "#{pid_file}"
      File.read("#{pid_file}").to_i
    rescue Errno::ENOENT
      fail "Unicorn doesn't seem to be running: #{pid_file} not found"
    end
  end

end
