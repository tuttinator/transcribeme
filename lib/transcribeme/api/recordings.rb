module TranscribeMe
  module API

    class Recordings

      attr_reader :list

      def initialize(session_id, client)
        @session_id, @client = session_id, client
      end

      def get_list!
        response = @client.call :get_customer_recordings, xml: xml
        @list = response.body[:get_customer_recordings_response][:get_customer_recordings_result][:recording_info]
      end

      private

      def xml
        xml = Builder::XmlMarkup.new.tag!(*SOAP_ENVELOPE) do |xml|
          xml.tag!("soapenv:Body") do |xml|
            xml.tag!("#{NAMESPACE_IDENTIFIER}:GetCustomerRecordings") do |xml|
              xml.tag!("#{NAMESPACE_IDENTIFIER}:sessionID") { |xml| xml.text! @session_id }
            end
          end
        end
      end

    end

  end
end
