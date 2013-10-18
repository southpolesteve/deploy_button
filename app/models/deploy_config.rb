class DeployConfig

  def initialize(response)
    @config = YAML.load(response)
  end

  def after_deploy
    @config && @config['after_deploy'] || []
  end

end