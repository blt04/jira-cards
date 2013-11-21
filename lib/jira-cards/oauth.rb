require 'oauth'
require 'securerandom'
require 'yaml'

require 'jira-cards/config'

module JiraCards
  class OAuth
    APP_NAME = 'jira-cards'
    # A fake URL used as the endpoint for the Jira Application Link
    APP_URL = "http://localhost:8988/#{APP_NAME}"

    def authorized?
      !!(config.access_token)
    end

    def authorize_url
      request_token.authorize_url
    end

    def config
      @config ||= JiraCards::Config.new
    end

    def consumer
      raise "Application is not linked" unless linked?

      @consumer ||= ::OAuth::Consumer.new(
        config.consumer_key,
        config.rsa_key,
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
      config.rsa_key = OpenSSL::PKey::RSA.new(2048)
      config.save!

      {
        app_name: APP_NAME,
        app_url: APP_URL,
        consumer_name: APP_NAME,
        consumer_key: config.consumer_key,
        public_key: config.rsa_public_key.to_pem,
      }
    end

    def linked?
      !!(config.jira_url && config.consumer_key && config.rsa_key)
    end

    def remove_authorization
      config.access_token = nil
      config.save!
    end

    def remove_consumer
      config.consumer_key = nil
      config.rsa_key = nil
      config.save!
    end

    def request_token
      @request_token ||= consumer.get_request_token
    end

    def verify_authorization(verification_code)
      access_token = request_token.get_access_token :oauth_verifier => verification_code
      if access_token
        config.access_token = access_token.token
        config.save!
      else
        false
      end
    end

  end
end
