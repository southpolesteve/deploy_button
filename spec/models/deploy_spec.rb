require 'spec_helper'

describe Deploy do
  let(:deploy) { create(:deploy) }

  describe ".begin_deploy" do
    before do
      deploy.should_receive :create_on_heroku
      deploy.begin_deploy
    end

    it "should record the start" do
      deploy.deploy_started_at.should_not be_nil
    end
  end

  describe ".create_on_heroku" do
    let(:create_response) { {test: "test"} }

    before do
      deploy.should_receive :clone
      HerokuBot.should_receive(:create).and_return(double(success?: true, to_hash: create_response ))
      deploy.create_on_heroku
    end

    it "should record the create" do
      deploy.created_on_heroku_at.should_not be_nil
    end

    it "should transition states" do
      deploy.state.should eq("created_on_heroku")
    end

    it "should save the create response" do
      deploy.create_response.should eq(create_response)
    end

  end

  describe ".clone" do
    let(:deploy) { create(:deploy_created_on_heroku, state: 'created_on_heroku') }

    before do
      deploy.should_receive(:cleanup_local_repo)
      deploy.should_receive(:`).with(/git clone/)
      deploy.should_receive :push
      deploy.clone
    end

    it "should record the clone" do
      deploy.cloned_at.should_not be_nil
    end

    it "should transition states" do
      deploy.state.should eq("cloned")
    end
  end

  describe ".push" do
    let(:deploy) { create(:deploy_created_on_heroku, state: 'cloned') }

    before do
      deploy.should_receive(:cleanup_local_repo).ordered
      deploy.should_receive(:`).with(/remote add heroku/)
      deploy.should_receive(:`).with(/push heroku master/)
      deploy.should_receive :add_user
      deploy.push
    end

    it "should record the push" do
      deploy.pushed_to_heroku_at.should_not be_nil
    end

    it "should transition states" do
      deploy.state.should eq("pushed")
    end
  end

  describe ".add_user" do
    let(:deploy) { create(:deploy_created_on_heroku, state: 'pushed') }

    before do
      HerokuBot.should_receive(:add_user_as_collaborator).with(deploy).and_return(double(success?: true))
      deploy.should_receive :request_transfer
      deploy.add_user
    end

    it "should transition states" do
      deploy.state.should eq("user_added")
    end
  end

  describe ".request_transfer" do
    let(:deploy) { create(:deploy_created_on_heroku, state: 'user_added') }

    before do
      HerokuBot.should_receive(:transfer).with(deploy).and_return(double(:success? => true, :[] => '12345' ))
      deploy.should_receive :accept_transfer
      deploy.request_transfer
    end

    it "should transition states" do
      deploy.state.should eq("transfer_requested")
    end

    it "should save the transfer id" do
      deploy.transfer_id.should_not be_nil
    end
  end

  describe ".accept_transfer" do
    let(:deploy) { create(:deploy_created_on_heroku, state: 'transfer_requested') }

    before do
      deploy.user.heroku.should_receive(:accept_transfer).with(deploy).and_return(double(:success? => true))
      deploy.should_receive :remove_bot
      deploy.accept_transfer
    end

    it "should transition states" do
      deploy.state.should eq("transfer_accepted")
    end
  end

  describe ".remove_bot" do
    let(:deploy) { create(:deploy_created_on_heroku, state: 'transfer_accepted') }

    before do
      HerokuBot.should_receive(:remove_bot).with(deploy).and_return(double(:success? => true))
      deploy.remove_bot
    end

    it "should transition states" do
      deploy.state.should eq("completed")
    end
  end

  describe ".heroku_name" do
    let(:deploy) { create(:deploy_created_on_heroku) }

    it "is correct" do
      deploy.heroku_name.should eq("afternoon-brook-7719")
    end
  end

end
