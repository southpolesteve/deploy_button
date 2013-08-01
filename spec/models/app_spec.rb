require 'spec_helper'

describe App do
  let(:app) { build(:app) }

  describe ".deploy" do
    it "should call the proper methods in the correct order" do
      app.should_receive(:create_on_heroku).ordered
      app.should_receive(:clone_to_local).ordered
      app.should_receive(:push_to_heroku).ordered
      app.should_receive(:transfer_to_user).ordered
      app.deploy
    end
  end

  describe ".heroku_name" do
    let(:app) { build(:app_created_on_heroku) }

    it "is correct" do
      app.heroku_name.should eq("afternoon-brook-7719")
    end
  end

end
