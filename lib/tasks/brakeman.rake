namespace :brakeman do

  desc "Run Brakeman"
  task :run, :output_files do |t, args|
    puts "\nScanning for security issues ..."
    require 'brakeman'

    files = []
    files = args[:output_files].split(' ') if args[:output_files]
    files << 'tmp/brakeman.html'
    files << 'tmp/brakeman.json'
    files << 'tmp/brakeman-output.tabs'
    Brakeman.run :app_path => ".", :output_files => files, :print_report => true, :output_formats => [:to_json, :to_html]

    require 'yaml'
    report_filename = "tmp/brakeman.json"
    report = JSON.parse(File.read(report_filename))
    warnings = report['scan_info']['security_warnings']
    if warnings > 0
      message = "Brakeman detected #{warnings} security warning(s)"
      message << "\nSee tmp/brakeman.html for details\n\n"
      fail message
    else
      puts "Scan complete with #{warnings} known warning(s)"
    end
  end

end