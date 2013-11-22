module JiraCards
class Config
  CONFIG_FILE = File.join(ENV['HOME'], '.jira-cards')

  # Config hash read from the YAML file on disk
  attr_reader :config
  # URL of your JIRA instance
  attr_accessor :jira_url

  attr_accessor :access_token
  
  attr_accessor :consumer_key

  attr_accessor :rsa_key

  def load
    @config       = config_hash_from_yaml
    @rsa_key      = initialized_rsa_key 
    @access_token = config[:access_token]
    @consumer_key = config[:consumer_key]
    @jira_url     = config[:jira_url]
  end

  def initialized_rsa_key
    OpenSSL::PKey::RSA.new(config['rsa_key'])
  end

  def config_hash_from_yaml
    YAML::load(File.open(CONFIG_FILE)) rescue {}
  end

  def save!
    File.open(CONFIG_FILE, 'w+', 0600) do |io|
      io.write(@config.to_yaml)
    end
  end

  #def rsa_key=(rsa_key)
    #@rsa_key = rsa_key
    #if rsa_key
      #@config['rsa_key'] = rsa_key.to_pem
    #else
      #@config['rsa_key'] = nil
    #end
  #end

  def rsa_public_key
    if rsa_key
      rsa_key.public_key
    else
      nil
    end
  end

end
end
