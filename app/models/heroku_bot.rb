class HerokuBot
  include HTTParty
  base_uri "https://api.heroku.com/"

  class << self

    def account
      get("/account", :headers => headers)
    end

    def transfer(app)
      post "/account/app-transfers", 
        :headers => headers, 
        :body => { 
          :app => { 
            :id => app.id,
            :name => app.name }, 
          :recipient => { 
            :id => app.user.heroku_id,
            :email => app.user.email 
          }
        }.to_json
    end

    def create
      post "/apps", :headers => headers 
    end

    private

    def headers
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
end