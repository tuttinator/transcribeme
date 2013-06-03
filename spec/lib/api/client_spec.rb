require 'transcribeme'
require 'spec_helper'

describe TranscribeMe::API::Client do
  
  before :all do
    @client = TranscribeMe::API::Client.new 
  end

  it "should be valid" do
    @client.should_not be_nil
  end

end