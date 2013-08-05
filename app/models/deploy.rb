class Deploy < ActiveRecord::Base
  belongs_to :user
  delegate :email, to: :user, prefix: true


  state_machine :state, :initial => :queued do

      before_transition :queued => :created_on_heroku, :do => :create_on_heroku
      before_transition :created_on_heroku => :cloned, :do => :clone
      before_transition :cloned => :pushed, :do => :push
      before_transition :pushed => :user_added, :do => :add_user
      before_transition :user_added => :transfer_requested, :do => :request_transfer
      before_transition :transfer_accepted => :bot_removed, :do => :accept_transfer
      before_transition :bot_removed => :completed, :do => :remove_bot

      after_transition any => any - :completed, :do => :proceed

      event :proceed do
        transition :queued => :created_on_heroku
        transition :created_on_heroku => :cloned
        transition :cloned => :pushed
        transition :pushed => :user_added
        transition :user_added => :transfer_requested
        transition :transfer_requested => :transfer_accepted
        transition :transfer_accepted => :bot_removed
        transition :bot_removed => :completed
      end

  end

  def heroku_name
    create_response['name'] if create_response
  end

  def github_url
    "https://github.com/#{owner}/#{name}.git"
  end

  private

  def create_on_heroku
    touch(:deploy_started_at)
    update_attributes create_response: HerokuBot.create.to_hash
    touch(:created_on_heroku_at)
  end

  def push
    GitSSHWrapper.with_wrapper(private_key: ENV['HEROKU_BOT_SSH_KEY']) do |wrapper|
      wrapper.set_env
      `git --git-dir #{repo_git_dir_loc} remote add heroku #{heroku_url}`
      `git --git-dir #{repo_git_dir_loc} push heroku master`
      cleanup_local_repo
    end
    touch(:pushed_to_heroku_at)
  end

  def add_user
    HerokuBot.add_user_as_collaborator(self)
  end

  def request_transfer
    transfer_response = HerokuBot.transfer(self)
    self.update_attributes(transfer_id: transfer_response['id'] )
  end

  def accept_transfer
    user.heroku.accept_transfer(self)
    touch(:transfered_at)
  end

  def remove_bot
    HerokuBot.remove_bot(self)
  end

  def clone
    cleanup_local_repo
    `git clone #{github_url} #{repo_loc}`
    touch(:cloned_at)
  end

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

end
