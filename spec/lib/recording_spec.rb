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

    [:date_created, :duration, :id, :name, :status, :state, :[], :keys].each do |method|
      it "has a #{method.to_s} method" do
        expect(@recording).to respond_to method
      end
    end

  end

  describe 'private setter methods' do

    before :each do
      @recording = TranscribeMe::Recording.new({})
    end

    describe 'typecasting the duration to a float' do

      it 'changes an integer to a float' do
        @recording.duration = 32
        expect(@recording.duration).to eq(32.0)
        expect(@recording.duration.class).to eq(Float)
      end

      it 'changes a string to a float' do
        @recording.duration = "32"
        expect(@recording.duration).to eq(32.0)
        expect(@recording.duration.class).to eq(Float)
      end

    end

    describe 'the status attribute sets a human readable state string' do

      describe 'typecasting the status to an integer' do

        it 'changes a string to an integer' do
          @recording.status = "10"
          expect(@recording.status).to eq(10)
          expect(@recording.status.class).to eq(Fixnum)
        end

      end

      describe 'setting the state string' do

        it 'sets the state string when the status code for ready' do
          @recording.status = 10
          expect(@recording.state).to eq('Ready for Transcription')
        end

        it 'sets the state string when the status code for Processing Audio' do
          @recording.status = 35
          expect(@recording.state).to eq('Processing Audio')
        end

        it 'sets the state string when the status code for In Progress' do
          @recording.status = 40
          expect(@recording.state).to eq('In Progress')
        end

        it 'sets the state string when the status code for Completed' do
          @recording.status = 50
          expect(@recording.state).to eq('Completed')
        end

      end

    end

  end

end