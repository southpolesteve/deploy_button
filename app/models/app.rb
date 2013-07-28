class App < ActiveRecord::Base
  belongs_to :user

  def create_heroku_app
    update_attributes create_response: HerokuBot.create_app.to_hash unless create_response.present?
  end

  def repo_loc
    "/tmp/#{owner}-#{name}"
  end

  def repo_git_dir_loc
    "/tmp/#{owner}-#{name}"
  end

  def github_url
    "https://github.com/#{owner}/#{name}.git"
  end

  def heroku_url
    create_response['git_url']
  end

  def deploy_heroku_app
    clone
    GitSSHWrapper.with_wrapper(private_key: ENV['HEROKU_BOT_SSH_KEY']) do |wrapper|
      wrapper.set_env
      `git --git-dir #{repo_git_dir_loc} remote add heroku #{heroku_url}`
      `git --git-dir #{repo_git_dir_loc} push heroku master`
    end
  end

  def clone
    `git clone #{github_url} #{repo_loc}`
  end

end
