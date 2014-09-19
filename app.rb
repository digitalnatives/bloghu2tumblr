require 'bundler/setup'
require 'sass'
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
  register Sinatra::AssetPack
  use Rack::Session::Cookie
  use OmniAuth::Builder do
    provider :tumblr, ENV['CONSUMER_KEY'], ENV['CONSUMER_SECRET']
  end

  assets do
    serve '/js', :from => 'public/javascripts'
    serve '/css', :from => 'public/stylesheets'

    js :application, [
      '/js/jquery-1.11.1.min.js',
      '/js/chosen.jquery.min.js',
      '/js/main.js'
    ]
    css :application, [
      '/css/gumby.css',
      '/css/style.css',
      '/css/chosen.min.css',
    ]
  end

  get '/' do
    erb :index
  end

  get '/start' do
    erb :start
  end

  get '/auth/tumblr/callback' do
    auth = request.env['omniauth.auth']
    session[:tumblr_nick]   = auth['info']['nick']
    session[:tumblr_blogs]  = auth['info']['blogs']
    session[:tumblr_token]  = auth['credentials']['token']
    session[:tumblr_secret] = auth['credentials']['secret']

    redirect to('/start')
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
