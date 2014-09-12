require 'bundler/setup'
require_relative './lib/post'
require_relative './lib/blog_hu_parser'
Bundler.require(:default, :development)
Dotenv.load

$redis = Redis.new

class MigratorJob
  include Sidekiq::Worker
  include SidekiqStatus::Worker

  def perform(token, secret, blog_name, file_path)
    posts = BlogHuParser.posts_from(file_path)

    client = Tumblr::Client.new(
      consumer_key: ENV['CONSUMER_KEY'],
      consumer_secret: ENV['CONSUMER_SECRET'],
      oauth_token: token,
      oauth_token_secret: secret
    )

    self.total = posts.count
    posts.each_with_index do |post, post_index|
      at post_index
      puts "#{post.to_request_params}"
      client.create_post(:text,
                         "#{blog_name}.tumblr.com",
                         post.to_request_params
                        )
    end
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
