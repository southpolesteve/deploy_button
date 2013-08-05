require 'spec_helper'

describe Deploy do
  let(:deploy) { create(:deploy) }

  describe ".proceed" do
    it "should call the proper methods in the correct order" do
      deploy.should_receive(:create_on_heroku).ordered
      deploy.should_receive(:clone).ordered
      deploy.should_receive(:push).ordered
      deploy.should_receive(:add_user).ordered
      deploy.should_receive(:request_transfer).ordered
      deploy.should_receive(:accept_transfer).ordered
      deploy.should_receive(:remove_bot).ordered
      deploy.proceed
    end
  end

  describe ".heroku_name" do
    let(:deploy) { build(:deploy_created_on_heroku) }

    it "is correct" do
      deploy.heroku_name.should eq("afternoon-brook-7719")
    end
  end

end
