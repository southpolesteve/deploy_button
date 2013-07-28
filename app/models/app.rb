class App < ActiveRecord::Base
  belongs_to :user

  def create_heroku_app
    update_attributes create_response: HerokuBot.create_app.to_hash unless create_response.present?
  end

  def repo_loc
    "/tmp/#{owner}-#{name}"
  end

  def clone_from_github
    gritty = Grit::Git.new('/tmp/filling-in')
    gritty.clone({:quiet => true, :verbose => false, :progress => false}, "git@github.com:southpolesteve/github-ember.git", repo_loc)
    # repo.git.remote({},'add','heroku',create_response['git_url']))
    # repo.git.push({}, 'heroku', 'master')
  end

  def repo
    Grit::Repo.new(repo_loc)
  end

end
