app = File.expand_path( "../app", __FILE__ )
$LOAD_PATH.unshift( app ) unless $LOAD_PATH.include?( app )

require "rubygems"
require "sinatra/base"
require "logger"
require "json"
require "bootstrap"

module QurayolaQuran
  class App < Sinatra::Base
    ::Logger.class_eval { alias :write :'<<' }
    access_log = "#{Dir.pwd}/logs/access.log"
    access_logger = ::Logger.new( access_log )

    error_log = "#{Dir.pwd}/logs/error.log"
    error_logger = ::File.new( error_log, "a+" )
    error_logger.sync = true

    configure do
      use ::Rack::CommonLogger, access_logger
      enable :logging
    end

    before {
      env[ "rack.errors" ] = error_logger
    }

    get "/" do
      content_type :json
      QurayolaQuran::Controllers::Home.instance.randomize
    end

    post "/", &QurayolaQuran::Controllers::Q.instance.handle

    not_found do
      content_type :json
      QurayolaQuran::Controllers::Home.instance.randomize
    end

    error do
      content_type :json
      QurayolaQuran::Controllers::Home.instance.randomize
    end

    # $0 is the executed file
    # __FILE__ is the current file
    run! if __FILE__ == $0
  end
end