require 'transcribeme'
require 'securerandom'
require 'spec_helper'

describe TranscribeMe::Recording do

  describe 'Class Methods' do

    subject(:recordings) { TranscribeMe::Recording }

    describe '"respond_to"s' do

      [:all, :list, :to_a, :new_from_soap, :inspect, :to_s, :completed, 
        :in_progress, :processing_audio, :ready_for_transcription, :ready].each do |method|

        it "has a #{method.to_s} method" do
          expect(recordings).to respond_to method
        end

      end

      it 'aliases the all method to list' do
        expect(recordings.list).to eq recordings.all
      end

      it 'aliases the all method to to_a' do
        expect(recordings.to_a).to eq recordings.all
      end

      it 'aliases the inspect method to to_s' do
        expect(recordings.to_s).to eq recordings.inspect
      end

      it 'aliases the ready_for_transcription to ready' do
        expect(recordings.ready).to eq recordings.ready_for_transcription
      end

    end
  end

  describe 'instance methods' do

    before :all do
      ready_hash = {  date_created: DateTime.now, 
                      duration: 200.59, 
                      id: SecureRandom.uuid, 
                      name: "Sample Recording", 
                      status: 10, 
                      state: "Ready for Transcription" }

      @recording = TranscribeMe::Recording.new(ready_hash)
    end

    [:date_created, :duration, :id, :name, :status, :state].each do |method|
      it "has a #{method.to_s} method" do
        expect(@recording).to respond_to method
      end
    end

  end

end