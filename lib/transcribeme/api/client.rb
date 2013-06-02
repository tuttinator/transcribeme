module TranscribeMe
  module API

    class Client

      attr_reader :client
      
      def initialize
        @client = Savon.client(wsdl: WSDL, endpoint: ENDPOINT, namespace: NAMESPACE, namespace_identifier: NAMESPACE_IDENTIFIER)
        initialize_session!
      end


      def initialize_session!
        @session = Session.new(@client)
        @session.create_on_server!
      end

      def login_with(username, password)
        initialize_session! unless @session.try :valid?
        @customer_login_id = CustomerLogin.new(@session.session_id, username, password, @client).login_on_server!
      end

      def get_recordings
        raise "Login first!" unless @customer_login_id
        @recordings = Recordings.new(@session.session_id, @client).get_list!
      end

      def submit_recording(recording)
        initialize_session! unless @session.try :valid?
        Submission.new(@session.session_id, recording, @client).submit!
      end

      def submit_recording_with_promocode(recording, promocode)
        initialize_session! unless @session.try :valid?
        SubmissionWithPromocode.new(@session.session_id, recording, promocode, @client).submit!
      end

      def get_status(recording_id)
        raise "Login first!" unless @customer_login_id
        CheckTranscriptionReady.new(@session.session_id, recording_id, @client).check!
      end

      def get_upload_url
        raise "Login first!" unless @customer_login_id
        UploadUrl.new(@session.session_id, @client).retrieve!
      end

      def logout!
        raise "Login first!" unless @customer_login_id
        FinalizeSession.new(@session.session_id, @client).submit!
      end

    end

  end
end
