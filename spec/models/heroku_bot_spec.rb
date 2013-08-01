require 'spec_helper'

describe HerokuBot do
  let(:app) { build(:app_created_on_heroku) }

  describe 'account' do
    it 'calls the correct HTTParty method' do
      HerokuBot.should_receive(:get).with('/account')
      HerokuBot.account
    end
  end

  describe 'transfer' do
    it 'calls the correct HTTParty method' do
      HerokuBot.should_receive(:post).with('/account/app-transfers', an_instance_of(Hash))
      HerokuBot.transfer(app)
    end
  end

  describe 'add_user_as_collaborator' do
    it 'calls the correct HTTParty method' do
      HerokuBot.should_receive(:post).with('/apps/afternoon-brook-7719/collaborators', an_instance_of(Hash))
      HerokuBot.add_user_as_collaborator(app)
    end
  end

  describe 'remove_bot' do
    it 'calls the correct HTTParty method' do
      HerokuBot.should_receive(:delete).with('/apps/afternoon-brook-7719/collaborators/test@example.com')
      HerokuBot.remove_bot(app)
    end
  end
  

  describe 'create' do
    it 'calls the correct HTTParty method' do
      HerokuBot.should_receive(:post).with('/apps')
      HerokuBot.create
    end
  end
end
