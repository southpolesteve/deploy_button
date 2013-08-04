require 'sidekiq/web'

Sidekiq::Web.use(Rack::Auth::Basic) do |user, password|
  [user, password] == [ENV['ADMIN_USERNAME'], ENV['ADMIN_PASSWORD']]
end