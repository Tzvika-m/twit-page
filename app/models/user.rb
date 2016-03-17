class User < ActiveRecord::Base
  # creates the user if it doensn't exist, anyway updates it's details
  def self.find_or_create_by_auth(auth_hash)
  	user = User.where(uid: auth_hash.uid).first_or_create
  	user.update(
  	  name: auth_hash.info.name,
  	  token: auth_hash.credentials.token,
  	  secret: auth_hash.credentials.secret
  	)
  	user
  end

  def twitter
  	@client ||= Twitter::REST::Client.new do |config|
  	  config.consumer_key        = Rails.application.secrets.twitter_api_key
	    config.consumer_secret     = Rails.application.secrets.twitter_api_secret
	    config.access_token        = token
	    config.access_token_secret = secret
  	end
  	@client
  end

end
