require 'transcribeme'
require 'spec_helper'

describe TranscribeMe::API::Client do

  before :all do
    @client = TranscribeMe::API::Client.new
  end

  it 'assigns an instance to a variable' do
    @client.should_not be_nil
  end

  describe 'initializing a session' do

    before :each do
      VCR.use_cassette('new_session') do
        @client.initialize_session
      end
    end

    it 'has a session id property' do
      @client.session_id.should_not be_nil
    end

    it 'uses the session id in the VCR fixture' do
      @client.session_id.should == '3ab295eb-ad02-4cef-90f0-fad5e294298e'
    end

    it 'has an expiry time that is in the future' do
      @client.session_expiry_time.should > Time.now
    end

  end

  describe 'logging in as a customer' do

    context 'before initializing a session' do

      before :all do
        @another_client = TranscribeMe::API::Client.new
      end

      it 'logs in with a valid username and password' do
        VCR.use_cassette('successful_sign_in') do
          @result = @another_client.sign_in('example@transcribeme.com', 'example')
        end

        @result.should == '65a747ae-0ea4-46a4-afb0-2b76901005ae'
      end

    end

    context 'after initializing a session' do

      it 'logs in'

    end


  end

end