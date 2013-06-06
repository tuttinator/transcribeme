require 'transcribeme'
require 'spec_helper'

describe TranscribeMe::API::Client do
  
  before :all do
    VCR.use_cassette('new_session') do
      @client = TranscribeMe::API::Client.new 
    end
  end

  it "should be valid" do
    @client.should_not be_nil
  end

end