require "twitter"
class TwitterClient

  def initialize
    @client = Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV["CONSUMER_KEY"]
      config.consumer_secret     = ENV["CONSUMER_SECRET"]
      config.access_token        = ENV["ACCESS_TOKEN"]
      config.access_token_secret = ENV["ACCESS_TOKEN_SECRET"]
    end
  end

  def method_missing(method_, *args, &block)
    @client.send(method_, *args, &block)
  rescue HTTP::ConnectionError, OpenSSL::SSL::SSLError
    retry
  end

end
