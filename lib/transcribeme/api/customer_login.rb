module TranscribeMe
  module API

    class CustomerLogin

      attr_reader :customer_id

      def initialize(session_id, username, password, client)
        @session_id, @username, @password, @client = session_id, username, password, client
      end

      def login_on_server!
        response = @client.call :sign_in, xml: xml
        @customer_id = response.body[:sign_in_response][:sign_in_result]
      end

      private

      def xml
        xml = Builder::XmlMarkup.new.tag!(*SOAP_ENVELOPE) do |xml|
          xml.tag!("soapenv:Body") do |xml|
            xml.tag!("#{NAMESPACE_IDENTIFIER}:SignIn") do |xml|
              xml.tag!("#{NAMESPACE_IDENTIFIER}:sessionID") { |xml| xml.text! @session_id }
              xml.tag!("#{NAMESPACE_IDENTIFIER}:username")  { |xml| xml.text! @username }
              xml.tag!("#{NAMESPACE_IDENTIFIER}:password")  { |xml| xml.text! @password }
            end
          end
        end
      end

    end
  end
end
