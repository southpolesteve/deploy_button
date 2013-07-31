Rails.application.config.middleware.use OmniAuth::Builder do
  provider :heroku, ENV['HEROKU_OAUTH_KEY'], ENV['HEROKU_OAUTH_SECRET'], scope: 'identity'
end
