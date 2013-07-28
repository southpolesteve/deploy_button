class HerokuBot
  include HTTParty
  base_uri "https://api.heroku.com/"

  def self.account
    get("/account", :headers => headers)
  end

  def self.transfer(app)
    post "/app-transfers", 
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

  def self.headers
    { "Authorization" => "Basic #{auth_key}",
      "Accept" => "application/vnd.heroku+json; version=3" }
  end

  def self.create_app
    post("/apps", :headers => headers)
  end

  def self.auth_key
    @auth_key ||= Base64.encode64(":#{api_key}")
  end

  def self.api_key
    ENV['HEROKU_BOT_API_KEY']
  end

  def self.email
    ENV['HEROKU_BOT_EMAIL']
  end

end