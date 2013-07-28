class Heroku
  include HTTParty
  base_uri "https://api.heroku.com/"

  def initialize(token)
    @token = token
  end

  def account
    self.class.get("/account", :headers => { "Authorization" => "Bearer #{@token}" })
  end
end