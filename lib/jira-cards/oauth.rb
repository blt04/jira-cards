module JiraCards
  class OAuth

    def access_token
      @access_token ||= ::OAuth::AccessToken.new(consumer, config.access_token, config.access_secret)
    end

    def authorized?
      !!(config.access_token && config.access_secret)
    end

    def authorize_url
      request_token.authorize_url
    end

    def config
      @config ||= begin
        # Load existing config if it exists
        JiraCards::Config.load
      rescue Errno::ENOENT
        # Or create a blank config
        JiraCards::Config.new
      end
    end

    def consumer
      raise "Application is not linked" unless linked?

      @consumer ||= ::OAuth::Consumer.new(
        config.consumer_key,
        config.consumer_private_key,
        {
          site: config.jira_url,
          signature_method: 'RSA-SHA1',
          scheme: :header,
          http_method: :post,
          request_token_path: '/plugins/servlet/oauth/request-token',
          access_token_path: '/plugins/servlet/oauth/access-token',
          authorize_path: '/plugins/servlet/oauth/authorize',
        }
      )
    end

    def create_consumer(jira_url)
      config.jira_url = jira_url
      config.consumer_key = SecureRandom.hex(16)
      config.consumer_private_key = OpenSSL::PKey::RSA.new(2048)
      config.save!

      {
        app_name: JiraCards::FAKE_JIRA_APP_NAME,
        app_url: JiraCards::FAKE_APP_URL,
        consumer_name: JiraCards::FAKE_JIRA_APP_NAME,
        consumer_key: config.consumer_key,
        public_key: config.consumer_public_key,
      }
    end

    def linked?
      !!(config.jira_url && config.consumer_key && config.consumer_private_key)
    end

    def remove_authorization
      config.access_token = nil
      config.save!
    end

    def remove_consumer
      config.consumer_key = nil
      config.consumer_secret = nil
      config.save!
    end

    def request_token
      @request_token ||= consumer.get_request_token
    end

    def verify_authorization(verification_code)
      access_token = request_token.get_access_token :oauth_verifier => verification_code
      if access_token
        config.access_token = access_token.token
        config.access_secret = access_token.secret
        config.save!
      else
        false
      end
    end

  end
end
