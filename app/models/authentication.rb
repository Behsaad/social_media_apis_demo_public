class Authentication < ActiveRecord::Base
  # Relations
  belongs_to :user

  validates_presence_of :user 
  validates :user, uniqueness: true

    # Class methods
  def self.user_from_omniauth(omniauth)

    authentication = where(provider: omniauth.provider, uid: omniauth.uid)
      .first_or_create do |auth|
        # assign user
        auth.user = User.new(provider: omniauth.provider)
        auth.user.email = omniauth.info.email.blank? ? "placeholder@demo.de" : omniauth.info.email
        auth.user.password = Devise.friendly_token[0,20]
        auth.user.username = "user_#{User.all.length}_#{Devise.friendly_token[0,5]}"
        auth.user.save!
        # assign attributes
        auth.secret = omniauth.credentials.secret
        auth.token =  omniauth.credentials.token

        if omniauth.credentials.refresh_token!=nil
          auth.refresh_token=omniauth.credentials.refresh_token
        end

        if omniauth.credentials.expires_at.present?
          auth.expires_at = Time.at(omniauth.credentials.expires_at.to_i)
        end
      end

    authentication.user
  end 

end
