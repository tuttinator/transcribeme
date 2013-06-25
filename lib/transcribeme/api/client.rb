module TranscribeMe
  module API

    class Client

      attr_accessor :session_id
      attr_reader :savon, :session_expiry_time
      
      def initialize
        @savon = ::Savon.client(wsdl: WSDL, endpoint: ENDPOINT, namespace: NAMESPACE, soap_version: 1)
      end

      def initialize_session!
        response = @savon.call :initialize_session
        # Without ActiveSupport
        #   1.hour.from_now is 3600 seconds from Time.now
        @session_expiry_time = Time.now + 3600
        @session_id = response.body[:initialize_session_response][:initialize_session_result]
      end

      def login_with(username, password)
        
        initialize_session! unless session_valid?

        response = @savon.call  :sign_in, 
                                message: {  "wsdl:sessionID"  => @session_id, 
                                            "wsdl:username"   =>  username, 
                                            "wsdl:password"   =>  password }

        @customer_login_id = response.body[:sign_in_response][:sign_in_result]

      end

      def get_recordings
        raise "Login first!" unless @customer_login_id

        response = @savon.call  :get_customer_recordings, 
                                message: {  "wsdl:sessionID" => session_id }

        @recordings = response.body[:get_customer_recordings_response][:get_customer_recordings_result][:recording_info]                                
      end

      def get_upload_url
        raise "Login first!" unless @customer_login_id

        response = @savon.call  :get_upload_url, 
                                message: {  "wsdl:sessionID" => @session_id }
                                
        @upload_url = response.body[:get_upload_url_response][:get_upload_url_result] 

      end

      def submit_recording(recording)
        initialize_session! unless @session.try :valid?
        Submission.new(@session.session_id, recording, @savon).submit!
      end

      def submit_recording_with_promocode(recording, promocode)
        initialize_session! unless @session.try :valid?
        SubmissionWithPromocode.new(@session.session_id, recording, promocode, @savon).submit!
      end

      def get_status(recording_id)
        raise "Login first!" unless @customer_login_id
        CheckTranscriptionReady.new(@session.session_id, recording_id, @savon).check!
      end

      def logout!
        raise "Login first!" unless @customer_login_id
        FinalizeSession.new(@session.session_id, @savon).submit!
      end

      private

      def session_valid?
        @session_expiry_time > Time.now
      end

      

    end

  end
end
