class PriorityDeployWorker
  include Sidekiq::Worker
  sidekiq_options :queue => :priority

  def perform(id)
    deploy = Deploy.find(id)
    deploy.proceed
  end
end