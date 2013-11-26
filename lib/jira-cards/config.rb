module JiraCards
class Config
  CONFIG_FILE = File.join(ENV['HOME'], '.jira-cards')

  # URL of your JIRA instance
  attr_accessor :jira_url

  attr_accessor :access_token

  attr_accessor :access_secret

  attr_accessor :consumer_key

  attr_accessor :consumer_secret

  # Loads configuration from a YAML file
  def self.load(file=CONFIG_FILE)
    self.from_yaml(File.open(file))
  end

  def save!
    File.open(CONFIG_FILE, 'w+', 0600) do |io|
      io.write(to_yaml)
    end
  end

  # Set the consumer secret.
  #
  # Raise an error if this isn't a valid RSA private key.  JIRA relies
  # on RSA-SHA1 signatures and requires an RSA key.
  def consumer_secret=(consumer_secret)
    if consumer_secret.is_a?(OpenSSL::PKey::RSA)
      @consumer_secret = consumer_secret.to_pem

    elsif consumer_secret
      begin
        rsa_key = OpenSSL::PKey::RSA.new(consumer_secret)
      rescue OpenSSL::PKey::RSAError => e
        raise "Invalid consumer secret: #{e.message}"
      end
      unless rsa_key.private?
        raise "Invalid consumer secret"
      end
      @consumer_secret = rsa_key.to_pem

    else
      @consumer_secret = nil
    end
  end
  alias :consumer_private_key= :consumer_secret=

  def consumer_private_key
    OpenSSL::PKey::RSA.new(consumer_secret) rescue nil
  end

  def consumer_public_key
    consumer_private_key.public_key rescue nil
  end

  def to_hash
    instance_variables.inject({}) do |memo, var|
      # Loop over all instance variables, but only serialize
      # those with accessors
      key = var.to_s[1..-1]
      if respond_to?(key)
        val = send(key)
      end
      memo[key] = val
      memo
    end
  end

  def self.from_hash(hash)
    config = self.new
    hash.each do |key, val|
      if config.respond_to?("#{key}=")
        config.send("#{key}=", val)
      else
        config.instance_variable_set("@#{key}", val)
      end
    end
    config
  end

  def to_yaml
    to_hash.to_yaml
  end

  def self.from_yaml(yaml)
    hash = YAML::load(yaml)
    self.from_hash(hash)
  end

end
end
