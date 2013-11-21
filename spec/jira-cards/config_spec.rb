require "spec_helper"

module JiraCards
  describe Config do
    subject(:config)

    let(:valid_config_hash) do
      {api_key: "123456asdfgh", endpoint: "https://jira6.osdc.lax.rapid7.com"}
    end

    describe "initialization" do
      before :each do
        JiraCards::Config.stub(:config_hash_from_yaml)
      end

      it "should set the API key" do
        
      end

      it "should set the endpoint" do
        
      end
      
    end
  
  end
end
