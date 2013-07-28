class HerokuBot
  include HTTParty
  base_uri "https://api.heroku.com/"

  def self.account
    get("/account", :headers => { "Authorization" => "Basic #{auth_key}" })
  end

  def self.create_app
    post("/apps", :headers => { "Authorization" => "Basic #{auth_key}" })
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