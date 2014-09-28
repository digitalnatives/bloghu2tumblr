require 'bundler/setup'
require_relative './lib/post'
require_relative './lib/blog_hu_parser'
Bundler.require(:default, ENV.fetch('RACK_ENV') { 'development' })
Dotenv.load
require "sinatra/json"

$redis = Redis.new

Sidekiq.configure_client do |config|
  config.client_middleware do |chain|
    chain.add Sidekiq::Status::ClientMiddleware
  end
end

Sidekiq.configure_server do |config|
  config.server_middleware do |chain|
    chain.add Sidekiq::Status::ServerMiddleware, expiration: 30 * 60 # default
  end
  config.client_middleware do |chain|
    chain.add Sidekiq::Status::ClientMiddleware
  end
end

class MigratorJob
  include Sidekiq::Worker
  include Sidekiq::Status::Worker

  def perform(token, secret, blog_name, file_path)
    posts = BlogHuParser.posts_from(file_path)

    client = Tumblr::Client.new(
      consumer_key: ENV['CONSUMER_KEY'],
      consumer_secret: ENV['CONSUMER_SECRET'],
      oauth_token: token,
      oauth_token_secret: secret
    )

    total posts.count
    posts.each_with_index do |post, post_index|
      at post_index + 1
      puts "#{post.to_request_params}"
      client.create_post(:text,
                         "#{blog_name}.tumblr.com",
                         post.to_request_params
                        )
    end
  end
end

class App < Sinatra::Base
  use Rack::Session::Cookie secret: ENV.fetch('COOKIE_SECRET'),
                            expire_after: 3600
  use OmniAuth::Builder do
    provider :tumblr, ENV.fetch('CONSUMER_KEY'), ENV.fetch('CONSUMER_SECRET')
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
    job_id = MigratorJob.perform_async(
      session[:tumblr_token],
      session[:tumblr_secret],
      params[:blog_name],
      params[:source_file][:tempfile].path
    )

    redirect to("/migrate/#{job_id}")
  end

  get '/migrate/:job_id' do |job_id|
    if request.xhr?
      # {status: 'complete', update_time: 1360006573, vino: 'veritas'}
      data = Sidekiq::Status::get_all(job_id)

      percentage = Sidekiq::Status::pct_complete(job_id)
      json data.merge({
        at: Sidekiq::Status::at(job_id),
        total: Sidekiq::Status::total(job_id),
        progress: percentage.nan? ? 0 : percentage,
      })
    else
      erb :migrate
    end
  end
end
