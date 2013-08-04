class DeploysController < ApplicationController
  before_filter :authenticate_user!

  def new
    respond_to do |format|
      format.html do
        @deploy = current_user.deploys.where(owner: params[:owner], name: params[:name], transfered_at: nil).first
        if @deploy
          flash[:notice] = "It looks like you already have queued a deployment of that repo. Please be patient :)"
          redirect_to @deploy
        end
      end
      format.png { send_file Rails.root.join("public", "deploy_button.png"), type: "image/png", disposition: "inline" }
    end
  end

  def create
    @deploy = current_user.deploys.create!(deploy_params)
    DeployWorker.perform_async(@deploy.id)
    redirect_to @deploy
  end

  def show
    load_deploy
  end

  def charge
    load_deploy
    begin
      charge = Stripe::Charge.create \
        :amount => 500,
        :currency => "usd",
        :card => params[:stripeToken],
        :description => current_user.email

      PriorityDeployWorker.perform_async(@deploy.id)
      flash[:success] = "Thank you for your support! Your deploy has been added to the priority queue."
    rescue Stripe::CardError => e
      flash[:error] = e.message
    end
    redirect_to @deploy
  end

  private

  def load_deploy
    @deploy = current_user.deploys.find(params[:id])
  end

  def deploy_params
    params.require(:deploy).permit(:owner, :name)
  end

end
