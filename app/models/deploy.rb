class Deploy < ActiveRecord::Base
  belongs_to :user
  delegate :email, to: :user, prefix: true

  attr_accessor :halt_deployment

  state_machine :state, :initial => :queued do

      event :success do
        transition :queued => :created_on_heroku
        transition :created_on_heroku => :cloned
        transition :cloned => :pushed
        transition :pushed => :user_added
        transition :user_added => :transfer_requested
        transition :transfer_requested => :transfer_accepted
        transition :transfer_accepted => :completed
      end

      event :failure do
        transition :queued => :creation_on_heroku_failed
        transition :created_on_heroku => :clone_failed
        transition :cloned => :push_failed
        transition :pushed => :user_add_failed
        transition :user_added => :transfer_request_failed
        transition :transfer_requested => :transfer_accept_failed
        transition :transfer_accepted => :not_completed
      end

  end

  def start_or_continue_deploy
    case state
    when "queued"
      create_on_heroku
    when "created_on_heroku"
      clone
    when "cloned"
      clone
    when "pushed"
      add_user
    when "user_added"
      request_transfer
    when "transfer_requested"
      accept_transfer
    when "transfer_accepted"
      remove_bot
    when "completed"
    else
    end
  end

  def create_on_heroku
    touch(:deploy_started_at)
    response = HerokuBot.create
    if response.success?
      update_attributes create_response: response.to_hash
      touch(:created_on_heroku_at)
      success
      clone unless @halt_deployment
    else
      failure
    end
  end

  def clone
    cleanup_local_repo
    `git clone #{github_url} #{repo_loc}`
    touch(:cloned_at)
    success
    push unless @halt_deployment
  end

  def push
    GitSSHWrapper.with_wrapper(private_key: HerokuBot.ssh_key) do |wrapper|
      wrapper.set_env
      `git --git-dir #{repo_git_dir_loc} remote add heroku #{heroku_url}`
      `git --git-dir #{repo_git_dir_loc} push heroku master`
    end
    touch(:pushed_to_heroku_at)
    cleanup_local_repo
    success
    add_user unless @halt_deployment
  end

  def add_user
    response = HerokuBot.add_user_as_collaborator(self)
    if response.success? 
      success
      request_transfer unless @halt_deployment
    else
      failure
    end
  end

  def request_transfer
    response = HerokuBot.transfer(self)
    if response.success?
      self.transfer_id = response['id']
      success
      accept_transfer unless @halt_deployment
    else
      failure
    end
  end

  def accept_transfer
    response = user.heroku.accept_transfer(self)
    if response.success?
      touch(:transfered_at)
      success
      remove_bot unless @halt_deployment
    else
      failure
    end
  end

  def remove_bot
    response = HerokuBot.remove_bot(self)
    response.success? ? success : failure
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

  def heroku_name
    create_response['name'] if create_response
  end

  def github_url
    "https://github.com/#{owner}/#{name}.git"
  end

  def cleanup_local_repo
    `rm -rf #{repo_loc}`
  end

end
