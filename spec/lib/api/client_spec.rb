require 'transcribeme'
require 'spec_helper'

describe TranscribeMe::API::Client do

  GUID_REGEX = /[a-f0-9]{8}-[a-f0-9]{4}-4[a-f0-9]{3}-(:?8|9|a|b)[a-f0-9]{3}-[a-f0-9]{12}/

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
      expect(@client.session_id).to_not be_nil
    end

    it 'uses the session id in the VCR fixture' do
      expect(@client.session_id).to match GUID_REGEX
      expect(@client.session_id).to_not be '00000000-0000-0000-0000-000000000000'
    end

    it 'has an expiry time that is in the future' do
      @client.session_expiry_time.should > Time.now
    end

  end

  describe 'logging in as a customer' do

    context 'successfully' do

      context 'before initializing a session' do

        before :all do
          @another_client = TranscribeMe::API::Client.new
        end

        it 'logs in with a valid username and password' do
          VCR.use_cassette('successful_sign_in') do
            @result = @another_client.sign_in('example@transcribeme.com', 'example')
          end

          expect(@result).to match GUID_REGEX
          expect(@result).to_not be '00000000-0000-0000-0000-000000000000'
        end

      end

      context 'after initializing a session' do

        it 'logs in with a valid username and password' do
          VCR.use_cassette('successful_sign_in_after_initialize_call') do
            @client.initialize_session
            @result = @client.sign_in('example@transcribeme.com', 'example')
          end

          expect(@result).to match GUID_REGEX
          expect(@result).to_not be '00000000-0000-0000-0000-000000000000'
        end

      end

    end

    context 'unsuccessfully' do

      it 'logs in with an invalid username and password' do
        VCR.use_cassette('unsuccessful_sign_in') do
          @another_client = TranscribeMe::API::Client.new

          expect do 
            @another_client.sign_in('invalid_example@transcribeme.com', 'invalid_example')
          end.to raise_error "Provided credentials are invalid. Please check your login and password and try again."

        end

      end

    end
  end

  describe 'getting a list of recordings' do

    before :each do
      VCR.use_cassette('list_of_recordings') do
        @client.initialize_session
        @client.sign_in('example@transcribeme.com', 'example')
        @recordings = @client.get_recordings
      end
    end

    it 'returns an array of recordings' do
      expect(@recordings.class.to_s).to eq "Array"
    end

    describe 'recordings' do

      before :each do
        @recording = @recordings.first
      end

      it 'has properties' do
        expect(@recording.keys).to eq [:date_created, :duration, :id, :name, :status]
      end

    end

  end

  describe 'get an upload url' do

    before :each do
      VCR.use_cassette('upload_url') do
        @client.initialize_session
        @client.sign_in('example@transcribeme.com', 'example')
        @url = @client.get_upload_url
      end
    end

    it 'produces an upload url on Windows Azure Blob storage' do
      expect(@url).to start_with "https://transcribeme.blob.core.windows.net/recordings/"
    end

  end

  describe 'upload a file' do


    it 'uploads successfully'

  end

end