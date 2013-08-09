require 'oauth'
require 'tumblr_client'

class UserSessions 
  def initialize
    @callback_url = ""
    @consumer = ""
  end



  def session

    @callback_url = "#{@@user_url}"
    @consumer = OAuth::Consumer.new("key", "secret", :site => "https://tumblr.com")
    
  end
  
  
end

