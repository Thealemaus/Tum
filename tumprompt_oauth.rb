# Setting up a client

require 'tumblr-oauth'

TumblrOAuth.configure do |config|
  config.consumer_key       = '1Juytw0l16Op1GODcv13lK9B0ySwVQom63lr9EsS246oIoYFM4'
  config.consumer_secret    = 'plo1wb96DeIHtUXm7FE6ZnB5cgX5jDmKSDtYxntSsbzMVvOcz1'
end

tumblr_client = TumblrOAuth::Client.new(
  :oauth_token        => 'UNHfxvjiHbdPjIK548xhKCaDnC8Wlre4zWDqZKXyMrmtewygHf',
  :oauth_token_secret => 'yCu1HWfnpUI80wnnwowB09SQcu2xAjG11chSiyXYe2bRQek085',
  :blog_host          => 'underated-dummy.tumblr.com' # For example "test.tumblr.com"
)


puts tumblr_client.user_info