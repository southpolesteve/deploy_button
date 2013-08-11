class DeployWorker
  include Sidekiq::Worker
  sidekiq_options :queue => :default, :retry => false

  def perform(id)
    deploy = Deploy.find(id)
    deploy.start_or_continue_deploy
  end
end