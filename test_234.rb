require 'sinatra'
require 'sinatra/namespace'
require 'json'
require 'app-version'
require 'app-logging'

class Test234 < Sinatra::Base

  register Sinatra::Namespace

  configure do
    $logger = AppLogging.logger
  end

  error do
    $logger.error "status=500, referrer_url=#{request.referer}, request_url=#{request.fullpath}"
    $logger.error request.env['sinatra.error'].message
    $logger.error request.env['sinatra.error'].backtrace.join("\n")
    'Test234 Internal Error'
  end

  get '/v1' do
    {
      '_links' => {
        'self' => { 'href' => '/v1' },
        'home' => { 'href' => '/' }
      }
    }.to_json
  end

  namespace '/v1' do
    get '/' do
      $logger.info request
      "Test234 home page"
    end
  end

  get '/' do
    redirect '/v1/'
  end

  get '/healthcheck' do
    $logger.info request
    "OK"
  end

end
