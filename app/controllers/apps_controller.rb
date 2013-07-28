class AppsController < ApplicationController
  def show
    @app = current_user.apps.find(params[:id])
    @app.deploy_async
  end
end