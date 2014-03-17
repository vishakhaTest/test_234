begin
  require 'metric_fu'

  namespace :metrics do

    desc 'Run all metrics specific to self-care'
    task :run do
      puts "\nGenerating metrics (this may take several minutes) ..."
      metrics = [:saikuro, :churn, :flay, :flog, :hotspots, :reek, :roodi, :stats]
      MetricFu::Run.new.run(metrics.inject({}) {|acc, m| acc[m] = true; acc })
    end

    desc 'Extract a summary of results from the last metrics report run'
    task :summary do
      require 'yaml'
        report_filename = "tmp/metric_fu/report.yml"
        report = YAML.load(File.read(report_filename))

        puts "\nM E T R I C S:\n"
        puts "\nFlay (structural similarities): #{report[:flay][:total_score]} issues found."
        puts "Saikuro (cyclomatic complexity over '4'):"
        report[:saikuro][:classes].each do |clazz|
          puts "  class #{clazz[:name]} has a complexity of #{clazz[:complexity]}" if clazz[:complexity] > 4
        end
        puts "Roodi (ruby design issues): #{report[:roodi][:total].join(' ')}"
        puts "\nFor details see code metrics report: tmp/metric_fu/output/index.html"
    end
  end
rescue LoadError
end
