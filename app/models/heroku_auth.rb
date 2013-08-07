class HerokuAuth
  include HTTParty
  base_uri "https://id.heroku.com/"

  def self.update_token(token)
    post("/oauth/token", :body => { :grant_type => 'refresh_token', :refresh_token => token, :client_secret => ENV['HEROKU_OAUTH_SECRET']}, :headers => { "Accept" => "application/vnd.heroku+json; version=3" })
  end

end