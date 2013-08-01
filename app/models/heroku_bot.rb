class HerokuBot
  include HTTParty
  base_uri "https://api.heroku.com/"

  class << self

    def account
      get "/account" 
    end

    def transfer(app)
      post "/account/app-transfers", 
        :body => { 
          :app => { 
            :name => app.heroku_name }, 
          :recipient => { 
            :email => app.user_email 
          }
        }.to_json
    end

    def add_user_as_collaborator(app)
      post "/apps/#{app.heroku_name}/collaborators", 
        body: { collaborator: { email: app.user.email } }
    end

    def remove_bot(app)
      delete "/apps/#{app.heroku_name}/collaborators/#{ENV['HEROKU_BOT_EMAIL']}"
    end

    def create
      post "/apps"
    end

    private

    def auth_headers
      { "Authorization" => "Basic #{auth_key}", "Accept" => "application/vnd.heroku+json; version=3" }
    end

    def auth_key
      @auth_key ||= Base64.encode64(":#{api_key}")
    end

    def api_key
      ENV['HEROKU_BOT_API_KEY']
    end

    def email
      ENV['HEROKU_BOT_EMAIL']
    end

  end

  headers auth_headers
end