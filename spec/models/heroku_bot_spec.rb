require 'spec_helper'

describe HerokuBot do
  describe 'account' do
    it 'calls the correct HTTParty method' do
      HerokuBot.should_receive(:get).with('/account', an_instance_of(Hash))
      HerokuBot.account
    end
  end

  describe 'transfer' do
    it 'calls the correct HTTParty method' do
      HerokuBot.should_receive(:post).with('/account/app-transfers', an_instance_of(Hash))
      HerokuBot.transfer(app)
    end
  end

  describe 'create' do
    it 'calls the correct HTTParty method' do
      HerokuBot.should_receive(:post).with('/apps', an_instance_of(Hash))
      HerokuBot.create
    end
  end
end
