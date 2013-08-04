require 'spec_helper'

describe Deploy do
  let(:deploy) { create(:deploy) }

  describe ".deploy" do
    it "should call the proper methods in the correct order" do
      deploy.should_receive(:create_on_heroku).ordered
      deploy.should_receive(:clone_to_local).ordered
      deploy.should_receive(:push_to_heroku).ordered
      deploy.should_receive(:transfer_to_user).ordered
      deploy.to_heroku
      deploy.deploy_started_at.should_not be_nil
    end
  end

  describe ".heroku_name" do
    let(:deploy) { build(:deploy_created_on_heroku) }

    it "is correct" do
      deploy.heroku_name.should eq("afternoon-brook-7719")
    end
  end

end
