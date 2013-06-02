module TranscribeMe
  module API
    class CheckTranscriptionReady
      def initialize(session_id, recording_id, client)
        @session_id, @recording_id, @client = session_id, recording_id, client
      end

      def check!
        response = @client.call :check_transcription_ready, xml: xml
        response.body[:check_transcription_ready_response][:check_transcription_ready_result]
      end

      private

      def xml
        xml = Builder::XmlMarkup.new.tag!(*SOAP_ENVELOPE) do |xml|
          xml.tag!("soapenv:Body") do |xml|
            xml.tag!("#{NAMESPACE_IDENTIFIER}:CheckTranscriptionReady") do |xml|
              xml.tag!("#{NAMESPACE_IDENTIFIER}:sessionID") { |xml| xml.text! @session_id }
              xml.tag!("#{NAMESPACE_IDENTIFIER}:recId") { |xml| xml.text! @recording_id }
            end
          end
        end
      end
      
    end

  end
end
