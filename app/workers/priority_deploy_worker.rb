class PriorityDeployWorker
  include Sidekiq::Worker
  sidekiq_options :queue => :priority, :retry => false

  def perform(id)
    deploy = Deploy.find(id)
    deploy.start_or_continue_deploy
  end
end