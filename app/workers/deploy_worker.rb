class DeployWorker
  include Sidekiq::Worker
  sidekiq_options :queue => :default, :retry => false, :backtrace => true

  def perform(id)
    deploy = Deploy.find(id)
    deploy.proceed
  end
end