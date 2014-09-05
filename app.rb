require 'bundler/setup'
Bundler.require(:default, :development)
Dotenv.load

class App < Sinatra::Base
  enable :sessions, :logging

  use Rack::Session::Cookie
  use OmniAuth::Builder do
    provider :tumblr, ENV['CONSUMER_KEY'], ENV['CONSUMER_SECRET']
  end

  get '/' do
    erb :index
  end

  get '/auth/tumblr/callback' do
    auth = request.env['omniauth.auth']
    session[:tumblr_nick]   = auth['info']['nick']
    session[:tumblr_blogs]  = auth['info']['blogs']
    session[:tumblr_token]  = auth['credentials']['token']
    session[:tumblr_secret] = auth['credentials']['secret']

    redirect to('/')
  end

  post '/upload' do
    'fuck yeah'
  end
end
