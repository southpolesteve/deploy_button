class DeployController < ApplicationController
  before_filter :authenticate_user!

  def new
    respond_to do |format|
      format.html do
        if current_user
          @app = current_user.apps.where(owner: params[:owner], name: params[:name], transfered_at: nil).first
          if @app
            flash[:notice] = "Looks like you already have queed a deployment of that repo. Please be patient."
            redirect_to @app
          end
        end
      end
      format.png { send_file Rails.root.join("public", "deploy_button.png"), type: "image/png", disposition: "inline" }
    end
  end

end
