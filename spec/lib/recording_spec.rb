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

    describe '"respond_to"s' do
    
      it 'has an all method' do
        expect(recordings).to respond_to :all
      end

      it 'aliases the all method to list' do
        expect(recordings).to respond_to :list
        expect(recordings.list).to eq recordings.all
      end

      it 'aliases the all method to to_a' do
        expect(recordings).to respond_to :to_a
        expect(recordings.to_a).to eq recordings.all
      end

      it 'has a new_from_soap method' do
        expect(recordings).to respond_to :new_from_soap
      end

      it 'has an inspect method' do
        expect(recordings).to respond_to :inspect
      end

      it 'aliases the inspect method to to_s' do
        expect(recordings).to respond_to :to_s
        expect(recordings.to_s).to eq recordings.inspect
      end

      it 'has a completed method' do
        expect(recordings).to respond_to :completed
      end

      it 'has a in_progress method' do
        expect(recordings).to respond_to :in_progress
      end

      it 'has a processing_audio method' do
        expect(recordings).to respond_to :processing_audio
      end

      it 'has a ready_for_transcription method' do
        expect(recordings).to respond_to :ready_for_transcription
      end

      it 'aliases the ready_for_transcription to ready' do
        expect(recordings).to respond_to :ready
        expect(recordings.ready).to eq recordings.ready_for_transcription
      end

    end

  end

end