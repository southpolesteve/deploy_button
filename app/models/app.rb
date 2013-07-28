class App < ActiveRecord::Base
  belongs_to :user

  def deploy
    create_on_heroku
    push_to_heroku
    transfer_to_user
  end

  def create_on_heroku
    update_attributes create_response: HerokuBot.create_app.to_hash unless create_response.present?
  end

  def push_to_heroku
    clone
    GitSSHWrapper.with_wrapper(private_key: ENV['HEROKU_BOT_SSH_KEY']) do |wrapper|
      wrapper.set_env
      `git --git-dir #{repo_git_dir_loc} remote add heroku #{heroku_url}`
      `git --git-dir #{repo_git_dir_loc} push heroku master`
      cleanup_repo
    end
  end

  def transfer_to_user
    # Heroku platform API endpoint for app transfers seems to be currently broken. Using legacy API.
    heroku = HerokuLegacy.new(HerokuBot.api_key)
    heroku.add_collaborator(self)
    heroku.transfer(self)
    heroku.remove_bot(self)
  end

  private

  def repo_loc
    "/tmp/#{owner}-#{name}"
  end

  def repo_git_dir_loc
    "/tmp/#{owner}-#{name}/.git"
  end

  def github_url
    "https://github.com/#{owner}/#{name}.git"
  end

  def heroku_url
    create_response['git_url']
  end

  def cleanup_repo
    `rm -rf #{repo_loc}`
  end

  def clone
    cleanup_repo
    `git clone #{github_url} #{repo_loc}`
  end

end
