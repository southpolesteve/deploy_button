# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    email "test@example.com"
    provider "heroku" 
    token "j123k1231kn2312jkn32kj3"
    heroku_id "asdasdad@users.heroku.com"
    token_expires_at { Time.now + 2.days }
    refresh_token "qweqwe23123n12j3n12"
  end
end
