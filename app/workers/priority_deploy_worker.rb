class PriorityDeployWorker
  include Sidekiq::Worker
  sidekiq_options :queue => :priority

  def perform(app_id)
    app = App.find(app_id)
    app.deploy
  end
end