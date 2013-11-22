require 'oauth'
require 'securerandom'
require 'yaml'
require 'highline'
require 'thor'

require 'jira-cards/version'
require 'jira-cards/oauth'
require 'jira-cards/config'


module JiraCards
  # OAuth authorizes "applications".  We are pretending to have one here to make JIRA happy.
  FAKE_JIRA_APP_NAME = "jira-cards"
  
  # A fake URL used as the endpoint for the Jira Application Link
  FAKE_APP_URL = "http://localhost:8988/#{JiraCards::FAKE_JIRA_APP_NAME}"
end
