class HerokuBot
  include HTTParty
  base_uri "https://api.heroku.com/"

  class << self

    def account
      response = get "/account" 
      handle_response(response)
      response
    end

    def transfer(app)
      response = post "/account/app-transfers", 
        :body => { 
          :app => { 
            :name => app.heroku_name }, 
          :recipient => { 
            :email => app.user_email 
          }
        }
      handle_response(response)
      response
    end

    def add_user_as_collaborator(app)
      response = post "/apps/#{app.heroku_name}/collaborators", 
        body: { user: { email: app.user.email } }
      handle_response(response)
      response
    end

    def remove_bot(app)
      response = delete "/apps/#{app.heroku_name}/collaborators/#{CGI.escape(ENV['HEROKU_BOT_EMAIL'])}"
      handle_response(response)
      response
    end

    def create
      response = post "/apps"
      handle_response(response)
      response
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

    def handle_response(response)
      unless response.success?
        raise response.body
      end
    end

  end

  headers auth_headers
end