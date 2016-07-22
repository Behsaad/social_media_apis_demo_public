
    class YoutubeTokenStore 
    

      # Load the token data from storage for the given ID.
      #
      # @param [String] id
      #  ID of token data to load.
      # @return [String]
      #  The loaded token data.
      def load(_id)
        credentials=User.find(_id).authentication
        json = MultiJson.dump(
          client_id: GOOGLE_CLIENT_ID,
          access_token: credentials.token,
          refresh_token: credentials.refresh_token,
          scope: GOOGLE_YT_SCOPE,
          expiration_time_millis: (credentials.expires_at.to_i) * 1000)
      end

      # Put the token data into storage for the given ID.
      #
      # @param [String] id
      #  ID of token data to store.
      # @param [String] token
      #  The token data to store.
      def store(_id, _token)
        credentials=JSON.parse(_token)
        old_credentials=User.find(_id).authentication
        old_credentials.refresh_tokens(credentials["access_token"], credentials["refresh_token"])
      end

      # Remove the token data from storage for the given ID.
      #
      # @param [String] id
      #  ID of the token data to delete
      def delete(_id)
        fail 'Not implemented'
      end
    end
