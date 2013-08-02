class AppsController < ApplicationController

  def index
    @apps = current_user.apps
  end

  def create
    @app = current_user.apps.create!(person_params)
    redirect_to @app
  end

  def show
    load_app
    @app.deploy_async
  end

  def charge
    load_app
    begin
      charge = Stripe::Charge.create \
        :amount => 500,
        :currency => "usd",
        :card => params[:stripeToken],
        :description => current_user.email

    rescue Stripe::CardError => e
      flash[:error] = e.message
    end
    redirect_to @app
  end

  private

  def load_app
    @app = current_user.apps.find(params[:id])
  end

  def person_params
    params.require(:app).permit(:owner, :name)
  end

end