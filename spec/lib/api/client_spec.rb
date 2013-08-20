require 'transcribeme'
require 'spec_helper'

describe TranscribeMe::API::Client do
  
  before :all do
    @client = TranscribeMe::API::Client.new
  end

  it "assigns an instance to a variable" do
    @client.should_not be_nil
  end

  describe "initializing a session" do

    before :each do
      VCR.use_cassette('new_session') do
        @client.initialize_session
      end
    end

    it "has a session id property" do
      @client.session_id.should_not be_nil
    end

    it "uses the session id in the VCR fixture" do
      @client.session_id.should == "3ab295eb-ad02-4cef-90f0-fad5e294298e"
    end

  end

end