require 'spec_helper'

describe HerokuBot do
  let(:deploy) { build(:deploy_created_on_heroku) }

  describe 'account' do
    it 'calls the correct HTTParty method' do
      HerokuBot.should_receive(:get).with('/account').and_return(double(success?: true))
      HerokuBot.account
    end
  end

  describe 'transfer' do
    it 'calls the correct HTTParty method' do
      HerokuBot.should_receive(:post).with('/account/app-transfers', an_instance_of(Hash)).and_return(double(success?: true))
      HerokuBot.transfer(deploy)
    end
  end

  describe 'add_user_as_collaborator' do
    it 'calls the correct HTTParty method' do
      HerokuBot.should_receive(:post).with('/apps/afternoon-brook-7719/collaborators', an_instance_of(Hash)).and_return(double(success?: true))
      HerokuBot.add_user_as_collaborator(deploy)
    end
  end

  describe 'remove_bot' do
    it 'calls the correct HTTParty method' do
      HerokuBot.should_receive(:delete).with('/apps/afternoon-brook-7719/collaborators/test%40example.com').and_return(double(success?: true))
      HerokuBot.remove_bot(deploy)
    end
  end

  describe 'create' do
    it 'calls the correct HTTParty method' do
      HerokuBot.should_receive(:post).with('/apps').and_return(double(success?: true))
      HerokuBot.create
    end
  end
end
