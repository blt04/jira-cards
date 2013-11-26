jira-cards
==========

Make index-card-sized PDFs of your JIRA stories


## OAuth

Using OAuth authentication is a two step process.  First you authorize the jira-cards application via Jira's Application Links.  Then you generate an OAuth token for your user account.

### Create Application Link

A Jira Administrator must create a an Application Link in Jira.  Send your Jira Administrator the output from the `create-link` command:

    jira-cards create-link

The `create-link` command will generate a random URL.  Jira will complain that it can't contact the jira-cards service.  You can safely ignore these messages since jira-cards is a command-line application and does not have a hosted service endpoint.

### Generate token

Run the `authorize` command:

    jira-cards authorize

This command will generate a link to view in your browser.  Follow the instructions to authorize the jira-cards application.  Jira should give you a verification code.  Copy and paste this code into the `Verification Code` prompt.  If successful, your OAuth access token will be generated.

### Using the Rest API via OAuth

Once you have completed the setup steps, accessing the Jira API is easy.  To get information on an issue:

    require 'jira-cards'
    token = JiraCards::OAuth.new.access_token
    response = token.get('https://your-jira-url/rest/api/2/issue/JIRA-1234')
    issue = JSON.parse(response.body)
    summary = issue['fields']['summary']
