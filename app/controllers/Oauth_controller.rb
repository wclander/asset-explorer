class TokenDecoder
  JWKS_URL = "https://login.eveonline.com/oauth/jwks"

  def initialize(token)
    @token = token
    @aud = 'EVE Online'
    @iss = 'login.eveonline.com'
  end

  def decode
    JWT.decode(
      @token,
      nil,
      true, # Verify the signature of this token
      algorithms: ["RS256"],
      iss: @iss,
      verify_iss: true,
      aud: @aud,
      verify_aud: true,
      jwks: fetch_jwks,
    )
  end

  private

  def fetch_jwks
    response = HTTP.get(JWKS_URL)
    if response.code == 200
      JSON.parse(response.body.to_s)
    end
  end
end

class OauthController < ApplicationController
  def initialize
    @oauth_client = OAuth2::Client.new(Rails.configuration.x.oauth.client_id,
                                       Rails.configuration.x.oauth.client_secret,
                                       authorize_url: '/v2/oauth/authorize/',
                                       site: Rails.configuration.x.oauth.idp_url,
                                       token_url: '/v2/oauth/token',
                                       redirect_uri: Rails.configuration.x.oauth.redirect_uri)
  end

  # The OAuth callback
  def oauth_callback
    begin
      # Make a call to exchange the authorization_code for an access_token
      response = @oauth_client.auth_code.get_token(params[:code])

      # Extract the access token from the response
      token = response.to_hash[:access_token]

      # Refresh token, should be stored for later use
      refresh_token = response.to_hash[:refresh_token]

      if params[:state] != Rack::Utils.escape(session[:state])
        return render(:file => File.join(Rails.root, 'public/403.html'), :status => 403, :layout => false)
      end
      # Decode the token
      decoded = TokenDecoder.new(token).decode
    rescue Exception => error
      render(:file => File.join(Rails.root, 'public/403.html'), :status => 403, :layout => false)
      raise "An unexpected exception occurred: #{error.inspect}"
    end

    # Set the token on the user session
    session[:access_token] = token.to_s
    session[:user_jwt] = {value: decoded, httponly: true}
    session[:logged_in] = true

    redirect_to root_path
  end

  def logout
    # EVE SSO does not provide logout url?
    #@oauth_client.request(:get, '/v2/oauth2/revoke')

    # Reset Rails session
    reset_session

    redirect_to root_path
  end

  def login
    # TODO APPEND STATE
    session[:state] = Rack::Utils.escape(OpenSSL::Digest.hexdigest('SHA256', Random.new.bytes(256)))
    redirect_to(@oauth_client.auth_code.authorize_url(state: session[:state]) + "&scope=" + Rack::Utils.escape(Rails.configuration.x.oauth.scopes), allow_other_host: true)
  end
end
