require File.expand_path('../app', __FILE__)

require 'sidekiq/web'
run Rack::URLMap.new('/' => App,
                     '/sidekiq' => Sidekiq::Web)
