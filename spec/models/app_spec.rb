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

end
