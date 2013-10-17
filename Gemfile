source 'https://rubygems.org'
ruby '2.0.0'

gem 'rails', '4.0.0'
gem 'pg'
gem 'sass-rails'
gem 'uglifier'
gem 'coffee-rails'
gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder'
gem 'figaro'
gem 'haml-rails'
gem 'omniauth'
gem 'omniauth-heroku'
gem 'thin'
gem 'httparty'
gem 'sidekiq'
gem 'git-ssh-wrapper'
gem 'pry-rails'
gem 'sidekiq'
gem 'slim'
gem 'sinatra'
gem 'sentry-raven'
gem 'stripe'
gem 'state_machine'

group :production do
  gem "rails_12factor"
  gem 'unicorn'
  gem 'autoscaler', require: false
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'html2haml'
  gem 'quiet_assets'
  gem 'spring'
end

group :development, :test do
  gem 'rspec-rails'
  gem 'factory_girl_rails'
end


group :test do
  gem 'capybara'
  gem 'vcr'
  gem 'webmock'
  gem 'selenium-webdriver'
  gem 'database_cleaner'
  gem 'coveralls', require: false
end
