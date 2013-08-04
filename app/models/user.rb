class User < ActiveRecord::Base

  has_many :deploys

  validates_uniqueness_of :email
  
  def self.find_or_create_with_omniauth(auth)
    token = auth['credentials']['token']
    heroku = HerokuPlatform.new(token)
    account = heroku.account
    user = where(email: account['email']).first_or_initialize
    user.provider ||= auth['provider']
    user.token = token
    user.heroku_id = account['id']
    user.save!
    user
  end

  def heroku
    @heroku_client ||= HerokuPlatform.new(token)
  end

end
