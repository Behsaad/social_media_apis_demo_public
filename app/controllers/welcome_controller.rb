class WelcomeController < ApplicationController

  require 'google/apis/youtube_v3'
  require 'google/apis/youtube_analytics_v1'
  require 'googleauth'
  require 'googleauth/token_store'

  def index
    if current_user.present?
      provider = current_user.authentication.provider
      @answer = query_provider(provider)
    end
  end


private

  def query_provider(provider)
   return query_facebook if provider == "facebook"
   return query_youtube if provider == "google_oauth2"
   return query_instagram if provider == "instagram"
   return query_twitter if provider == "twitter"
   return query_pinterest if provider == "pinterest"
  end


  def query_facebook
   token = current_user.authentication.token
   api = Koala::Facebook::API.new(token)
   api.get_object("me/posts").as_json
  end

  def query_youtube

    scope = GOOGLE_YT_SCOPE
    client_id = Google::Auth::ClientId.new(GOOGLE_CLIENT_ID, GOOGLE_CLIENT_SECRET)
    token_store = YoutubeTokenStore.new

    authorizer = Google::Auth::UserAuthorizer.new(client_id, scope, token_store)

    credentials = authorizer.get_credentials(current_user.id)
    client =  Google::Apis::YoutubeV3::YouTubeService.new

    if credentials.nil?
      url = authorizer.get_authorization_url(base_url: OOB_URI )
      puts "Open #{url} in your browser and enter the resulting code:"
      code = gets
      credentials = authorizer.get_and_store_credentials_from_code(
        user_id: user_id, code: code, base_url: OOB_URI)
    end
    
    client.authorization=credentials

    client.list_channels('snippet,id', mine: true).as_json
  end

  def query_instagram
    client = Instagram.client(:access_token => current_user.authentication.token)
    
    client.user_recent_media.as_json
  end

  def query_twitter

    authentication=current_user.authentication

    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = TWITTER_ID
      config.consumer_secret     = TWITTER_SECRET
      config.access_token        = authentication.token
      config.access_token_secret = authentication.secret
    end

    client.home_timeline.as_json
  end

  def query_pinterest
    authentication = current_user.authentication
    client = Pinterest::Client.new(authentication.token)
    
    client.get_pins({:fields=>"board, id, counts, image, note, created_at, url", :limit => 20 }).as_json
  end


end
