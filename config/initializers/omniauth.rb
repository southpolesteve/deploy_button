Rails.application.config.middleware.use OmniAuth::Builder do
  provider :heroku, ENV['OMNIAUTH_PROVIDER_KEY'], ENV['OMNIAUTH_PROVIDER_SECRET'], scope: 'identity'
end
