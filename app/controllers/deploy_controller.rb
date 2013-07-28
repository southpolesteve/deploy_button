class DeployController < ApplicationController
  def show
    app = current_user.apps.where(owner: params[:owner], name: params[:name]).first_or_create
    redirect_to app
  end
end
