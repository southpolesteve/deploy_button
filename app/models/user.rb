class User < ActiveRecord::Base

  has_many :apps
  
  def self.create_with_omniauth(auth)
    user = create! provider: auth['provider'], uid: auth['credentials']['token']
    heroku = HerokuPlatform.new(user.uid)
    account = heroku.account
    user.update_attributes email: account['email'], heroku_id: account['id']
    user
  end

end
