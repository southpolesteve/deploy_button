class SessionsController < ApplicationController

  def new
    redirect_to '/auth/heroku'
  end

  def create
    auth = request.env["omniauth.auth"]
    user = User.find_or_create_with_omniauth(auth)
    reset_session
    session[:user_id] = user.id
    redirect_to request.env['omniauth.origin'] || root_url
  end

  def destroy
    reset_session
    redirect_to root_url, :notice => 'Signed out!'
  end

end
