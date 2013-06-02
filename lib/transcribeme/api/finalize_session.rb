module TranscribeMe
  module API

    class FinalizeSession

      def initialize(session_id, client)
        @session_id, @client = session_id, client
      end

      def submit!
        response = @client.call :finalize_session, xml: xml
        response.body[:finalize_session_response][:finalize_session_result]
      end

      private

      def xml
        xml = Builder::XmlMarkup.new.tag!(*SOAP_ENVELOPE) do |xml|
          xml.tag!("soapenv:Body") do |xml|
            xml.tag!("#{NAMESPACE_IDENTIFIER}:FinalizeSession") do |xml|
              xml.tag!("#{NAMESPACE_IDENTIFIER}:sessionID") { |xml| xml.text! @session_id }
            end
          end
        end
      end

    end

  end
end
