require 'bundler/setup'
Bundler.require
Dotenv.load
require_relative './lib/post'

Tumblr.configure do |config|
  config.consumer_key       = ENV['CONSUMER_KEY']
  config.consumer_secret    = ENV['CONSUMER_SECRET']
  config.oauth_token        = ENV['OAUTH_TOKEN']
  config.oauth_token_secret = ENV['OAUTH_TOKEN_SECRET']
end

post = Post.new.tap do |p|
  p.type  = 'text'
  p.state = 'published'
  p.tags  = ['one', 'two', 'three']
  p.tweet = false
  p.date  = Time.new(2014, 7, 30, 2, 2, 2, '+02:00')
  p.format = 'html'
  p.slug = 'whatever'
  p.title = 'Something'
  p.body = 'Text <br> and a <p>one</p> <marquee>blink and scroll</marquee>'
end

client = Tumblr::Client.new
client.create_post(:text, 'dnfakeblog.tumblr.com', post.to_request_params)
