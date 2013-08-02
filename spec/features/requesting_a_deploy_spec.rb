require 'spec_helper'

describe 'User requests a deploy' do

  before do
    App.any_instance.should_receive(:deploy_async)
    HerokuPlatform.any_instance.should_receive(:account).and_return({'email'=>'test@example.com', 'id'=>'12312'})
  end

  it "queues a new app for deployment" do
    visit "/deploy/begriffs/lucre"
    click_on 'OK! Go!'
    page.should have_content("deploying a new instance of begriffs/lucre")
  end

end