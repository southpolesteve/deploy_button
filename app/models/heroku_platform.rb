class HerokuPlatform
  include HTTParty
  base_uri "https://api.heroku.com/"

  def initialize(token)
    @token = token
  end

  def account
    self.class.get("/account", :headers => { "Authorization" => "Bearer #{@token}", "Accept" => "application/vnd.heroku+json; version=3" })
  end

  def accept_transfer(app)
    self.class.patch("/account/app-transfers/#{app.transfer_id}", :body => { :state => "accepted" }, :headers => { "Authorization" => "Bearer #{@token}", "Accept" => "application/vnd.heroku+json; version=3" })
  end

end