module TranscribeMe
  module API

    class UploadUrl
      
      def initialize(session_id, client)
        @session_id, @client = session_id, client
      end

      def retrieve!
        response = @client.call :get_upload_url, xml: xml
        @list = response.body[:get_upload_url_response][:get_upload_url_result]
      end

      private

      def xml
        xml = Builder::XmlMarkup.new.tag!(*SOAP_ENVELOPE) do |xml|
          xml.tag!("soapenv:Body") do |xml|
            xml.tag!("#{NAMESPACE_IDENTIFIER}:GetUploadUrl") do |xml|
              xml.tag!("#{NAMESPACE_IDENTIFIER}:sessionID") { |xml| xml.text! @session_id }
            end
          end
        end
      end

    end

  end
end
