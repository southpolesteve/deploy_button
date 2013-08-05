class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user

    def current_user
      begin
        @current_user ||= User.find(session[:user_id]) if session[:user_id]
      rescue Exception => e
        nil
      end
    end

  private

    def authenticate_user!
      if !current_user
        redirect_to "/auth/heroku?origin=#{URI.escape(request.path)}"
      end
    end

end
