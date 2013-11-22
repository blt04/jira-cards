require "spec_helper"

module JiraCards
  describe Config do
    subject(:config){ JiraCards::Config.new }

    let(:valid_config_hash) do
      {
        jira_url: "123456asdfgh", 
        access_token: "fdsgaurjngfddfsfgfdskgdf",
        consumer_key: "fdsahlkjret61hr72947gj",
        rsa_key: "rsa key gobbledygook",
      }
    end

    describe "#load" do
      before :each do
        config.stub(:config_hash_from_yaml).and_return valid_config_hash
        config.stub(:initialized_rsa_key).and_return valid_config_hash[:rsa_key]
        config.load
      end

      it "should set the 'consumer_key'" do
        config.consumer_key.should == valid_config_hash[:consumer_key]
      end

      it "should set the 'access_token'" do
        config.access_token.should == valid_config_hash[:access_token]  
      end

      it "should set the 'rsa_key'" do
        config.rsa_key.should == valid_config_hash[:rsa_key]  
      end

      it "should set the 'jira_url'" do
        config.jira_url.should == valid_config_hash[:jira_url]  
      end
    end
  
  end
end
