class AuthenticationsController < Devise::OmniauthCallbacksController

  def facebook
    apply_omniauth("Facebook", "devise.facebook_data")
  end

  def google_oauth2
    apply_omniauth("Google", "devise.google_data")
  end

  def twitter
    apply_omniauth("Twitter", "devise.twitter_data")
  end

  def pinterest
    apply_omniauth("Pinterest", "devise.pinterest_data")
  end

  def instagram
    apply_omniauth("Instagram", "devise.instagram_data")
  end



  def apply_omniauth(provider, session_data)

    if current_user.present?

        redirect_to root_path

    else

      @user = Authentication.user_from_omniauth(request.env["omniauth.auth"])
    
      if @user.persisted?
        sign_in_and_redirect @user, :event => :authentication
      else
        session[session_data] = request.env["omniauth.auth"]
        redirect_to root_path
      end

    end  
  end  

end
