module TranscribeMe
  module API

    class SubmissionWithPromocode

      def initialize(session_id, recording_id, promocode, client)
        @session_id, @recording_id, @promocode, @client = session_id, recording_id, promocode, client
      end

      def submit!
        response = @client.call :transcribe_recording, xml: xml
        response.body[:transcribe_recording_response][:transcribe_recording_result]
      end

      private

      def xml
        xml = Builder::XmlMarkup.new.tag!(*SOAP_ENVELOPE) do |xml|
          xml.tag!("soapenv:Body") do |xml|
            xml.tag!("#{NAMESPACE_IDENTIFIER}:TranscribeRecording") do |xml|
              xml.tag!("#{NAMESPACE_IDENTIFIER}:sessionID") { |xml| xml.text! @session_id }
              xml.tag!("#{NAMESPACE_IDENTIFIER}:recordingID") { |xml| xml.text! @recording_id }
              xml.tag!("#{NAMESPACE_IDENTIFIER}:promocode") { |xml| xml.text! @promocode }
            end
          end
        end
      end

    end

  end
end
