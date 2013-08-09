require 'spec_helper'

describe User do
  let(:user) { create(:user) }

  describe ".heroku" do
    let(:user) { create(:user, token_expires_at: Time.now - 10.days) } 

    before do
      user.should_receive :update_token
      HerokuPlatform.should_receive(:new).with(user.token)
    end

    it "should call update_token" do
      user.heroku
    end

  end

  describe ".update_token" do
    let(:new_token) { "asdasdawdwqdwd" }

    before do
      response = double(success?: true)
      response.should_receive(:[]).with("expires_in").and_return(7199)
      response.should_receive(:[]).with("access_token").and_return(new_token)
      HerokuAuth.should_receive(:update_token).with(user.refresh_token).and_return(response)
    end

    it "should get a new token" do
      user.update_token
      user.token.should eq(new_token)
    end

  end
end
