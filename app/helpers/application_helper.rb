module ApplicationHelper
  require 'net/http'
  require 'net/https'
  require 'uri'
  
  @@token_url = "https://accounts.google.com/o/oauth2/auth?client_id=#{CLIENT_ID}&redirect_uri=#{REDIRECT_URI}&scope=#{SCOPE}&response_type=code&approval_prompt=force&access_type=offline"

  def youtube_authorize_path
    return @@token_url
  end

  def is_authorized(user)
    
  end
end
