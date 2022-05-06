class ApplicationController < ActionController::Base
  helper_method :current_user
  helper_method :logged_in?
  helper_method :character_id

  def current_user
    if session[:user_jwt]
      token = session[:user_jwt][:value].first

      if token && token["name"]
        @user_name = token["name"]
      end
    end
  end

  def character_id
    if session[:user_jwt]
      session[:user_jwt][:value].first["sub"].split(":")[2]
    end
  end
end
