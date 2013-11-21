module JiraCards
class Config
  CONFIG_FILE = File.join(ENV['HOME'], '.jira-cards')

  def initialize
    reload
  end

  def reload
    @config = YAML::load(File.open(CONFIG_FILE)) rescue {}
    @rsa_key = nil
  end

  def save!
    File.open(CONFIG_FILE, 'w+', 0600) do |io|
      io.write(@config.to_yaml)
    end
  end

  def access_token
    @config['access_token']
  end

  def access_token=(access_token)
    @config['access_token'] = access_token
  end

  def consumer_key
    @config['consumer_key']
  end

  def consumer_key=(consumer_key)
    @config['consumer_key'] = consumer_key
  end

  def jira_url
    @config['jira_url']
  end

  def jira_url=(jira_url)
    @config['jira_url'] = jira_url
  end

  def rsa_key
    if @config['rsa_key']
      @rsa_key ||= OpenSSL::PKey::RSA.new(@config['rsa_key'])
    else
      nil
    end
  end

  def rsa_key=(rsa_key)
    @rsa_key = rsa_key
    if rsa_key
      @config['rsa_key'] = rsa_key.to_pem
    else
      @config['rsa_key'] = nil
    end
  end

  def rsa_public_key
    if rsa_key
      rsa_key.public_key
    else
      nil
    end
  end

   def endpoint
     
   end
end
end
