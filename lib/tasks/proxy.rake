namespace :proxy do
	
	desc 'Remove any HTTP proxy settings from the Rails environment'
	task :clear do		
		puts "Removing HTTP_PROXY setting from Rails #{Rails.env} environment"
		ENV['HTTP_PROXY'] = ENV['http_proxy'] = nil 
		if RUBY_PLATFORM[/java/]
			require 'java'
			java.lang.System.clearProperty("http.proxyHost")
			java.lang.System.clearProperty("http.proxyPort")
		end	
	end

end