require "spec_helper"

module JiraCards
  describe Config do
    subject(:config){ JiraCards::Config.new }

    let(:valid_config_hash) do
      {
        jira_url: "123456asdfgh",
        access_token: "fdsgaurjngfddfsfgfdskgdf",
        access_secret: "ajs9qakfk123kdksdfi92lsf",
        consumer_key: "fdsahlkjret61hr72947gj",
        consumer_secret: private_key.to_pem,
      }
    end

    let(:private_key) do
      OpenSSL::PKey::RSA.new(128)
    end

    let(:public_key) do
      private_key.public_key
    end

    describe "#from_hash" do
      subject(:config){ JiraCards::Config.from_hash(valid_config_hash) }

      it "should set the 'consumer_key'" do
        config.consumer_key.should == valid_config_hash[:consumer_key]
      end

      it "should set the 'consumer_secret'" do
        config.consumer_secret.should == valid_config_hash[:consumer_secret]
      end

      it "should set the 'access_token'" do
        config.access_token.should == valid_config_hash[:access_token]
      end

      it "should set the 'access_secret'" do
        config.access_secret.should == valid_config_hash[:access_secret]
      end

      it "should set the 'jira_url'" do
        config.jira_url.should == valid_config_hash[:jira_url]
      end
    end

    describe "#consumer_private_key" do
      it "returns a RSA object" do
        config.consumer_secret = private_key
        config.consumer_private_key.should be_an(OpenSSL::PKey::RSA)
      end

      it "returns the private component of the consumer secret" do
        config.consumer_secret = private_key
        puts config.consumer_private_key.to_pem.should == private_key.to_pem
      end

      it "returns nil" do
        config.consumer_private_key.should be_nil
      end
    end

    describe "#consumer_public_key" do
      it "returns a RSA object" do
        config.consumer_secret = private_key
        config.consumer_public_key.should be_an(OpenSSL::PKey::RSA)
      end

      it "returns the public component of the consumer secret" do
        config.consumer_secret = private_key
        puts config.consumer_public_key.to_pem.should == public_key.to_pem
      end


      it "returns nil" do
        config.consumer_public_key.should be_nil
      end
    end

  end
end
