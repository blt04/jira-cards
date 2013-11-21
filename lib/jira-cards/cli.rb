require 'highline'
require 'thor'

module JiraCards
  class CLI < Thor
    class << self
      def fetch_story(story_id)
        
      end
    end

    desc "create-link", "Link the jira-cards application with Jira"
    method_option :force, :aliases => "-f", :type => :boolean, :desc => "Recreate the link if it already exists"
    method_option :url, :aliases => "-u", :desc => "Jira URL"
    def create_link
      require 'jira-cards/oauth'
      oauth = JiraCards::OAuth.new

      if oauth.linked?
        if options[:force]
          oauth.remove_consumer
        else
          $stderr.puts "ERROR: jira-cards is already linked.  Run with --force to re-link."
          exit 1
        end
      end

      if options[:url]
        jira_url = options[:url]
      else
        jira_url = ask("Jira URL:")
      end

      consumer = oauth.create_consumer(jira_url)
      puts <<EOS
Ask your Jira Administrator to create a new Application Link:

Application URL: #{consumer[:app_name]}
Application Name: #{consumer[:app_url]}
Application Type: Generic Application
No Outgoing Link
Incoming Link (check the "Create incoming link" box)

Incoming Consumer Key: #{consumer[:consumer_key]}
Incoming Consumer Name: #{consumer[:consumer_name]}
Incoming Public Key:\n#{consumer[:public_key]}

Since jira-cards is a CLI tool, the application URL will not actually
exist.  That is ok.

After the Jira Administrator creates the link, you can use the
generate-token command to generate an OAuth access token for
authentication.
EOS
    end

    desc "authorize", "Authorize the jira-cards application using your credentials"
    method_option :force, :aliases => "-f", :type => :boolean, :desc => "Reauthorize if an access token already exists"
    def authorize
      require 'jira-cards/oauth'
      oauth = JiraCards::OAuth.new

      unless oauth.linked?
        $stderr.puts "ERROR: jira-cards is not linked.  Please link with the create-link account before authorizing"
        exit 1
      end

      if oauth.authorized?
        if options[:force]
          # TODO: Delete existing link
          oauth.remove_authorization
        else
          $stderr.puts "ERROR: jira-cards is already authorized.  Run with --force to re-authorize."
          exit 1
        end
      end

      authorize_url = oauth.authorize_url

      puts <<EOS
Please visit the following URL below in your browser.  Follow the directions
to authorize the jira-cards app.

#{authorize_url}

After successfully authorizing jira-cards, Jira should give you a verification
code.  Enter it below:
EOS

      verification_code = ask("Verification Code:")
      if oauth.verify_authorization(verification_code)
        puts "SUCCESS!  Your OAuth access token is #{oauth.config.access_token}"
      else
        $stderr.puts "ERROR: There was an error generating your OAuth token"
        exit 1
      end
    end

  end
end
