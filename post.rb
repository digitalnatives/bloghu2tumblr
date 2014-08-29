require 'bundler/setup'
Bundler.require
Dotenv.load
require_relative './lib/post'
require_relative './lib/blog_hu_parser'

Tumblr.configure do |config|
  config.consumer_key       = ENV['CONSUMER_KEY']
  config.consumer_secret    = ENV['CONSUMER_SECRET']
  config.oauth_token        = ENV['OAUTH_TOKEN']
  config.oauth_token_secret = ENV['OAUTH_TOKEN_SECRET']
end

# TODO : filename arg to script
posts = BlogHuParser.posts_from File.join(File.dirname(__FILE__), "spec/fixtures/bloghu_digitalnatives_2014_07_10.xml")

client = Tumblr::Client.new

# TODO : destination config
posts.each do |p|
  client.create_post(:text, 'dnfakeblog.tumblr.com', p.to_request_params)
end
