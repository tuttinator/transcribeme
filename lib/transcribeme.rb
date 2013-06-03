require 'transcribeme/version'

module TranscribeMe
  module API

      WSDL = "http://transcribeme-api.cloudapp.net/PortalAPI.svc?wsdl=wsdl0"
      ENDPOINT = "http://transcribeme-api.cloudapp.net/PortalAPI.svc"
      NAMESPACE = "http://TranscribeMe.API.Web"
      NAMESPACE_IDENTIFIER = :tns # any indentifier can be used

      SOAP_ENVELOPE = ["soapenv:Envelope", { "xmlns:soapenv" => "http://schemas.xmlsoap.org/soap/envelope/", "xmlns:#{NAMESPACE_IDENTIFIER}" => NAMESPACE }]
    
  end
end

require 'transcribeme/api/client'
require 'transcribeme/api/customer_login'
require 'transcribeme/api/session'
require 'transcribeme/api/recordings'
require 'transcribeme/api/submission'
require 'transcribeme/api/submission_with_promocode'
require 'transcribeme/api/check_transcription_ready'
require 'transcribeme/api/upload_url'
