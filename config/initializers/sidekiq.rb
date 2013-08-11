require 'sidekiq/web'

Sidekiq::Web.use(Rack::Auth::Basic) do |user, password|
  [user, password] == [ENV['ADMIN_USERNAME'], ENV['ADMIN_PASSWORD']]
end

if Rails.env.production?
  require 'autoscaler/sidekiq'
  require 'autoscaler/heroku_scaler'

  Sidekiq.configure_client do |config|
    config.client_middleware do |chain|
      chain.add Autoscaler::Sidekiq::Client, 'default' => Autoscaler::HerokuScaler.new
    end
  end

  Sidekiq.configure_server do |config|
    config.server_middleware do |chain|
      chain.add(Autoscaler::Sidekiq::Server, Autoscaler::HerokuScaler.new, 60)
    end
  end
end