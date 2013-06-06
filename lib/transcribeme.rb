require 'transcribeme/version'

module TranscribeMe
  module API

      WSDL = "http://transcribeme-api.cloudapp.net/PortalAPI.svc?wsdl=wsdl0"
      ENDPOINT = "http://transcribeme-api.cloudapp.net/PortalAPI.svc"
      NAMESPACE = "http://TranscribeMe.API.Web"
      NAMESPACE_IDENTIFIER = :tns # any identifier can be used

      SOAP_ENVELOPE = ["soapenv:Envelope", { "xmlns:soapenv" => "http://schemas.xmlsoap.org/soap/envelope/", "xmlns:#{NAMESPACE_IDENTIFIER}" => NAMESPACE }]

      def self.construct_xml(soap_method, options = {})
        Builder::XmlMarkup.new.tag!(*SOAP_ENVELOPE) do |xml|
          xml.tag!("soapenv:Body") do |xml|
            xml.tag!("#{NAMESPACE_IDENTIFIER}:#{soap_method}") do |xml|
              options.each do |key, value|
                xml.tag!("#{NAMESPACE_IDENTIFIER}:#{key}") { |xml| xml.text! value }
              end
            end
          end
        end
      end
    
  end
end

require 'savon'

require 'transcribeme/api/client'
require 'transcribeme/api/customer_login'
require 'transcribeme/api/session'
require 'transcribeme/api/recordings'
require 'transcribeme/api/submission'
require 'transcribeme/api/submission_with_promocode'
require 'transcribeme/api/check_transcription_ready'
require 'transcribeme/api/upload_url'
