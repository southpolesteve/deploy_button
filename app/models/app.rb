class App < ActiveRecord::Base
  belongs_to :user
  delegate :email, to: :user, prefix: true

  def deploy_async
    DeployWorker.perform_async(id)
  end

  def deploy
    create_on_heroku
    clone_to_local
    push_to_heroku
    transfer_to_user
  end

  def create_on_heroku
    unless create_response.present?
      update_attributes create_response: HerokuBot.create.to_hash
      touch(:created_on_heroku_at)
    end
  end

  def push_to_heroku
    GitSSHWrapper.with_wrapper(private_key: ENV['HEROKU_BOT_SSH_KEY']) do |wrapper|
      wrapper.set_env
      `git --git-dir #{repo_git_dir_loc} remote add heroku #{heroku_url}`
      `git --git-dir #{repo_git_dir_loc} push heroku master`
      cleanup_local_repo
    end
    touch(:pushed_to_heroku_at)
  end

  def transfer_to_user
    HerokuBot.add_user_as_collaborator(self)
    HerokuBot.transfer(self)
    HerokuBot.remove_bot(self)
    touch(:transfered_at)
  end

  def heroku_name
    create_response['name'] if create_response
  end

  def github_url
    "https://github.com/#{owner}/#{name}.git"
  end

  private

  def repo_loc
    "/tmp/#{owner}-#{name}"
  end

  def repo_git_dir_loc
    "/tmp/#{owner}-#{name}/.git"
  end

  def heroku_url
    create_response['git_url']
  end

  def cleanup_local_repo
    `rm -rf #{repo_loc}`
  end

  def clone_to_local
    cleanup_local_repo
    binding.pry
    `git clone #{github_url} #{repo_loc}`
    touch(:cloned_at)
  end

end
