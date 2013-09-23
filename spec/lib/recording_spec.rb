require 'transcribeme'
require 'securerandom'
require 'spec_helper'

describe TranscribeMe::Recording do

  before :all do
    ready_hash = {  date_created: DateTime.now, 
                    duration: 200.59, 
                    id: SecureRandom.uuid, 
                    name: "Sample Recording", 
                    status: 10, 
                    state: "Ready for Transcription" }

    @recording = TranscribeMe::Recording.new(ready_hash)
  end

  describe 'Class Methods' do

    subject(:recordings) { TranscribeMe::Recording }

    it 'has an all method' do
      expect(recordings).to respond_to :all
    end

  end

end