module JiraCards
class Config
  # The REST endpoint of your JIRA instance
  attr_accessor :endpoint

  # Your API key
  attr_accessor :api_key

  # Where this Gem finds the connection information it needs
  PERMANENT_CONFIG_FILE_PATH = "~/.jira_cards_conf.yaml"

  def initialize
    conf_hash = config_hash_from_yaml 
    @endpoint = conf_hash[:endpoint]
    @api_key  = conf_hash[:api_key]
  end

  def self.config_hash_from_yaml
    YAML.load(PERMANENT_CONFIG_FILE_PATH)
  end
end
end
