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
    user.refresh_token = auth['credentials']['refresh_token']
    user.token_expires_at = Time.at(auth['credentials']['expires_at'])
    user.heroku_id = account['id']
    user.save!
    user
  end

  def heroku
    update_token if token_expires_at < Time.now - 10.minutes
    @heroku_client ||= HerokuPlatform.new(token)
  end

  def update_token
    response = HerokuAuth.update_token(refresh_token)
    if response.success?
      update_attributes(token: response['access_token'], token_expires_at: Time.now + response['expires_in'].seconds)
    end
  end

end
