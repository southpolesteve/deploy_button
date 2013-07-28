class DeployWorker
  include Sidekiq::Worker

  def perform(app_id)
    app = App.find(app_id)
    app.deploy
  end
end