class DeployWorker
  include Sidekiq::Worker

  def perform(id)
    deploy = Deploy.find(id)
    deploy.to_heroku
  end
end