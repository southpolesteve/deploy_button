require 'spec_helper'

describe 'User requests a deploy' do

  context "new deployment" do
    before do
      DeployWorker.should_receive(:perform_async)
      HerokuPlatform.any_instance.should_receive(:account).and_return({'email'=>'test@example.com', 'id'=>'12312'})
    end

    it "queues a new app for deployment" do
      visit "/deploy/begriffs/lucre"
      click_on 'OK! Go!'
      page.should have_content("deploying a new instance of begriffs/lucre")
    end
  end

  context "deployment already queued" do
    let(:app) { create :app }

    before do
      DeployWorker.should_receive(:perform_async).never
      HerokuPlatform.any_instance.should_receive(:account).and_return({'email'=> app.user_email, 'id'=>'12312'})
    end

    it "redirects to an existing app" do
      visit "/deploy/begriffs/lucre"
      page.should have_content("you already have queued a deployment of that repo")
    end
  end

end