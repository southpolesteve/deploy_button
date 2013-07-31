class HerokuLegacy
  include HTTParty
  base_uri "https://api.heroku.com/"

  def initialize(token)
    @token = token
  end

  def apps
    self.class.get("/apps", basic_auth: { username: "", password: @token })
  end

  def transfer(app)
    self.class.put("/apps/#{app.create_response['name']}", basic_auth: { username: "", password: @token }, body: { app: { transfer_owner: app.user.email } } )
  end

  def add_collaborator(app)
    self.class.post("/apps/#{app.create_response['name']}/collaborators", basic_auth: { username: "", password: @token }, body: { collaborator: { email: app.user.email } } )
  end

  def remove_bot(app)
    self.class.delete("/apps/#{app.create_response['name']}/collaborators/#{ENV['HEROKU_BOT_EMAIL']}", basic_auth: { username: "", password: @token } )
  end
  
end