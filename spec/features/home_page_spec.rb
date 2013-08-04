require 'spec_helper'

describe 'Home page' do

  it "exists" do
    visit "/"
    page.should have_content("Deploy any Github Repo to Heroku")
  end

end