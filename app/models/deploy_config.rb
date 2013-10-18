class DeployConfig

  def initialize(response)
    @config = YAML.load(response)
  end

  def after_deploy
    @config && @config['after_deploy']
  end

  def run_after_deploy
    if after_deploy
      responses = config.after_deploy.map { |command| HerokuBot.run(self, command) }
      response.all?
    else
      true
    end
  end

end