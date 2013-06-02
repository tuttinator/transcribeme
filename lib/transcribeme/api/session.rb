module TranscribeMe
  module API

    class Session

      attr_reader :session_id

      def initialize(client)
        @client = client
      end

      def create_on_server!
        response = @client.call :initialize_session, xml: xml
        @session_expiry_time = 1.hour.from_now
        @session_id = response.body[:initialize_session_response][:initialize_session_result]
      end

      def valid?
        Time.now < @session_expiry_time
      end

      private

      def xml
        xml = Builder::XmlMarkup.new.tag!(*SOAP_ENVELOPE) do |xml|
          xml.tag!("soapenv:Body") do |xml|
            xml.tag!("#{NAMESPACE_IDENTIFIER}:InitializeSession")
          end
        end
      end

    end

  end
end
