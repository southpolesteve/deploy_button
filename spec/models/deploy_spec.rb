require 'spec_helper'

describe Deploy do
  let(:deploy) { create(:deploy) }

  context 'state machine actions' do

    before do
      deploy.should_receive :start_or_continue_deploy
    end

    describe ".create_on_heroku" do
      let(:create_response) { {test: "test"} }

      before do
        HerokuBot.should_receive(:create).and_return(double(success?: true, to_hash: create_response ))
        deploy.create_on_heroku
      end

      it "should record the start" do
        deploy.deploy_started_at.should_not be_nil
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
        deploy.push
      end

      it "should record the push" do
        deploy.pushed_to_heroku_at.should_not be_nil
      end

      it "should transition states" do
        deploy.state.should eq("pushed")
      end
    end

    describe ".run_after_deploy" do
      let(:deploy) { create(:deploy_created_on_heroku, state: 'pushed') }
      let(:github_response) { "" }

      before do
        deploy.should_receive(:config).and_return(DeployConfig.new(github_response))
      end

      it "should transition states" do
        deploy.run_after_deploy
        deploy.state.should eq("after_deploy_complete")
      end

      context "config contains after_deploy commands" do
        let(:github_response) { "after_deploy:\n- rake db:migrate\n- a test command\n" }

        it "should run the commands on heroku" do
          HerokuBot.should_receive(:run).with(deploy, "rake db:migrate").and_return(double(success?: true))
          HerokuBot.should_receive(:run).with(deploy, "a test command").and_return(double(success?: true))
          deploy.run_after_deploy
        end

      end
    end

    describe ".add_user" do
      let(:deploy) { create(:deploy_created_on_heroku, state: 'after_deploy_complete') }

      before do
        HerokuBot.should_receive(:add_user_as_collaborator).with(deploy).and_return(double(success?: true))
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
  end

  describe ".heroku_name" do
    let(:deploy) { create(:deploy_created_on_heroku) }

    subject { deploy.heroku_name }

    it { should eq("afternoon-brook-7719") }
  end

  describe ".config" do
    let(:deploy) { create(:deploy) }

    it do
      HTTParty.should_receive(:get).with(deploy.config_url)
      DeployConfig.should_receive(:new)
      deploy.config
    end
  end

end
