# TranscribeMe
module TranscribeMe
  # API module
  module API
    # API Client with methods for interacting with the SOAP API
    class Client

      # Public: Returns the session id of the current session
      attr_reader :session_id
      # Public: Returns the expiry time of the current session
      attr_reader :session_expiry_time
      # Public: Returns the underlining Savon object
      attr_reader :savon
      # Public: Returns the last list of recordings
      attr_reader :recordings

      WSDL = 'http://transcribeme-api.cloudapp.net/PortalAPI.svc?wsdl=wsdl0'
      ENDPOINT = 'http://transcribeme-api.cloudapp.net/PortalAPI.svc'
      NAMESPACE = 'http://TranscribeMe.API.Web'

      # Public: Initializes the API Client class
      #
      def initialize
        # Note: Deliberately disabling the verbose Savon logging
        @savon = ::Savon.client(endpoint: ENDPOINT,  namespace: NAMESPACE,
                                soap_version: 1, wsdl: WSDL, log: false)
      end

      # Public: Initializes a session on the API server and stores 
      # the expiry time and the session_id in instance variables
      #
      # Returns the session_id GUID
      def initialize_session
        response = @savon.call :initialize_session
        # Without ActiveSupport
        #   1.hour.from_now is 3600 seconds from Time.now
        @session_expiry_time = Time.now + 3600
        @session_id = response.body[:initialize_session_response][:initialize_session_result]
      end

      # Public: Calls the 'SignIn' SOAP action
      #
      # username - a String which corresponds to a TranscribeMe Portal 
      #            account username which can be any valid email address
      # password - a String which is the portal account password
      #
      # Returns a GUID of the Customer ID
      def sign_in(username, password)
        
        # If #login_with is called before we have a session_id instance variable
        # then call initialize_session
        initialize_session unless session_valid?

        # Use Savon to call the 'SignIn' SOAP action
        response = @savon.call  :sign_in, 
                                message: {  'wsdl:sessionID'  => @session_id, 
                                            'wsdl:username'   =>  username, 
                                            'wsdl:password'   =>  password }

        error_message = response.body[:sign_in_response][:error_message]

        raise error_message if error_message

        # Assign the customer_login_id variable to the string in the SOAP response
        @customer_login_id = response.body[:sign_in_response][:sign_in_result]
      end

      # Public: Calls the 'GetCustomerRecordings' SOAP Action
      #
      # requires the user to be logged in
      #
      # Returns an Array of recording objects
      def get_recordings
        # raise 'Login first!' unless @customer_login_id

        response = @savon.call  :get_customer_recordings, 
                                message: {  'wsdl:sessionID' => session_id }

        # Returns an array of instances of the Recording class
        @recordings = TranscribeMe::Recording.new_from_soap response.body[:get_customer_recordings_response][:get_customer_recordings_result][:recording_info]
      end

      # Public: Calls the 'GetUploadUrl' SOAP Action
      #
      # Returns the upload url as a String
      def get_upload_url
        # raise 'Login first!' unless @customer_login_id

        response = @savon.call  :get_upload_url, 
                                message: {  'wsdl:sessionID' => @session_id }
                                
        @upload_url = response.body[:get_upload_url_response][:get_upload_url_result] 
      end

      # Public: uploads to Azure Blob Storage and commits the upload to
      # the TranscribeMe SOAP API
      #
      # file_path - a String with the path to the actual file
      # options   - a Hash with these keys:
      #             :multiple_speakers  - Boolean (default is true)
      #             :duration           - Float
      #             :description        - String
      #
      # Returns the response as a Hash
      def upload(file_path, options = {})

        # If not logged in, raise this exception
        raise 'Login first!' unless @customer_login_id

        # Extract options from the options hash
        multiple_speakers = options[:multiple_speakers] || true
        description       = options[:description]
        file_name         = File.basename(file_path)
        file_format       = File.extname(file_path)
        file_size         = File.stat(file_path).size
        # Use the duration if provided in the options hash
        duration          = options[:duration] || ::FFMPEG::Movie.new(file_path).duration

        # Use the last upload url, or grab a new one
        @upload_url ||= get_upload_url

        # Create a connection to the upload url
        connection = Excon.new(@upload_url)
        # Upload to 
        connection.put(headers: { "x-ms-blob-type" => "BlockBlob", 
                                  "x-ms-date" => Time.now.to_s, 
                                  "Content-Length" => file_size}, body: File.read(file_path))

        # Post to the 
        response = @savon.call :commit_upload, message: { "wsdl:sessionID"  => @session_id, 
                                                          "wsdl:url" => @upload_url, 
                                                          "wsdl:name" => file_name, 
                                                          "wsdl:description" => description, 
                                                          "wsdl:duration" => duration, 
                                                          "wsdl:source" => "Ruby API Client",
                                                          "wsdl:format" => file_format, 
                                            "wsdl:isMultipleSpeakers" => multiple_speakers }
                   
        # Set the upload url to nil so that we don't reuse it             
        @upload_url = nil

        response
      end

      # Public: Calls the 'TranscribeRecording' SOAP Action
      #
      # recording_id - a String in GUID format
      #
      # Returns the SOAP response Hash
      def transcribe_recording(recording_id)
        # initialize_session unless @session.try :valid?

        response = @savon.call :transcribe_recording, 
                               message: { 'wsdl:sessionID'   => @session_id, 
                                          'wsdl:recordingId' => recording_id }

        response.body[:transcribe_recording_response][:transcribe_recording_result]
      end

      # Public: Calls the 'TranscribeRecordingWithPromoCode' SOAP Action
      #
      # recording_id - a String in GUID format
      # promocode    - a String
      #
      # Returns the SOAP response Hash
      def transcribe_recording_using_promocode(recording_id, promocode)
        # initialize_session unless @session.try :valid?
        
        response = @savon.call :transcribe_using_promo_code, 
                               message: { 'wsdl:sessionID'   => @session_id, 
                                          'wsdl:recordingId' => recording_id,
                                          'wsdl:promoCode'   => promocode }

        response.body[:transcribe_using_promo_code_response][:transcribe_using_promo_code_result]
      end

      # Public: Calls the 'GetRecordingInfo' SOAP Action
      #
      # recording_id - a String in GUID format
      #
      # Returns the SOAP response Hash
      def get_recording_info(recording_id)
        response = @savon.call :get_recording_info,
                    message: { 'wsdl:sessionID'   => @session_id,
                               'wsdl:recordingID' => recording_id }
        response.body[:get_recording_info_response][:get_recording_info_result]
      end

      # Public: Calls the 'GetTranscription' SOAP Action to allow for 
      # downloading of transcriptions
      #
      # recording_id - a String in GUID format
      # format       - a Symbol - either :text, :rtf, :pdf, :html
      #
      # Returns the file data in a String to write to a file (decoded from Base64.)
      def get_transcription(recording_id, format = :text)
        format_type = case format
        when :text
          "Text"
        else
          format.to_s.upcase
        end

        response = @savon.call :get_transcription, message: { 'wsdl:sessionID' => @session_id, 
                                                              'wsdl:recId' => recording_id, 
                                                              'wsdl:formattingType' => format_type }

        error_message = response.body[:get_transcription_response][:error_message]
        raise error_message if error_message

        transcription = response.body[:get_transcription_response][:get_transcription_result]

        raise "Transcription unable to be downloaded" if transcription.nil?

        Base64.decode64(transcription)
      end

      # Public: Calls the 'FinalizeSession' SOAP Action to close 
      # the session on the server
      #
      # Returns the SOAP response Hash
      def finalize_session
        @savon.call  :finalize_session, 
                     message: { 'wsdl:sessionID' => @session_id }
      end

      private

      # Private: Checks if the session expiry time has passed
      #
      # Returns a Boolean
      def session_valid?
        @session_expiry_time > Time.now if @session_expiry_time
      end


    end

  end
end