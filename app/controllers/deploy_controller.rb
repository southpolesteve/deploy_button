class DeployController < ApplicationController
  def show
    respond_to do |format|
      format.html do
        if current_user
          app = current_user.apps.where(owner: params[:owner], name: params[:name]).first_or_create
          redirect_to app
        end
      end
      format.png { send_file Rails.root.join("public", "deploy_button.png"), type: "image/png", disposition: "inline" }
    end
  end
end
