class User < ActiveRecord::Base

  has_many :apps
  
  def self.find_or_create_with_omniauth(auth)
    token = auth['credentials']['token']
    heroku = HerokuPlatform.new(token)
    account = heroku.account
    user = where(email: account['email'], heroku_id: account['id']).first_or_initialize
    user.provider ||= auth['provider']
    user.token = token
    user.save!
    user
  end

end
