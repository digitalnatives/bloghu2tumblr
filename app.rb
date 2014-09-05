require 'bundler/setup'
Bundler.require(:default, :development)
Dotenv.load

$redis = Redis.new

class MigratorJob
  include Sidekiq::Worker

  def perform(token, secret, blog_name, file_path)
    puts token, secret, blog_name, file_path
  end
end

class App < Sinatra::Base
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
    MigratorJob.perform_async(
      session[:tumblr_token],
      session[:tumblr_secret],
      params[:blog_name],
      params[:source_file][:tempfile].path
    )

    redirect to('/migrate')
  end

  get '/migrate' do

  end
end
