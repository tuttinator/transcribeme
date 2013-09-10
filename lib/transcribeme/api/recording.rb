# TranscribeMe
module TranscribeMe
  # API module
  module API
    # representation of recording objects
    class Recording

      # Define attributes
      ATTRIBUTES = [:date_created, :duration, :id, :name, :status, :state]

      # Recording attributes
      ATTRIBUTES.each do |attr|
        attr_reader attr
      end

      # Define status codes
      STATUS_CODES = { 
        0  => "New",
        4  => "File Queued for Upload",
        6  => "Error during Upload",
        7  => "Empty File. Nothing to upload",
        8  => "Upload in Progress",
        10 => "Ready for Transcription",
        20 => "Awaiting Payment",
        30 => "Queued",
        33 => "TempBeforeHTK",
        35 => "Processing Audio",
        40 => "In Progress",
        50 => "Completed",
        90 => "Deleted" }


      # Public: Initializes the Recording class
      #
      # recording - Hash with attributes from SOAP response
      #
      def initialize(recording)
        recordings.each do |key, value|
          if ATTRIBUTES.member? key.to_sym
            self.send (key.to_s + "="), value
          end
        end
      end

      # Public: Hash-like access to the attributes
      #
      # key - String or Symbol
      #
      # Returns the result of that method call
      def [](key)
        self.send key.to_sym
      end

      def keys
        ATTRIBUTES
      end

      private

      # Private: Iterate through all attributes and define setter
      #  methods on them
      ATTRIBUTES.each do |attr|
        case attr
        when :status
          # Private: Sets the state as well as the status according
          #   to the status code
          #
          # value - string
          #
          # Returns the status code as an Integer
          define_method :status= do |value|
            @state = STATUS_CODES[value.to_i]
            @status = value.to_i
          end
        when :duration
          # Private: Sets the duration as a float
          #
          # value - string
          #
          # Returns the duration as an Float
          define_method :duration= do |value|
            @duration = value.to_f
          end
        else
          # Private: Setter methods for the date_created, id and 
          #   name attributes
          #
          # value - object
          #
          # Returns the Object after assigning to an instance variable
          define_method :"#{attr}=" do |value|
            instance_variable_set :"@#{attr}", value
          end
        end
      end

      # Class Methods
      class << self

        # Public: recording instances as a class instance
        #   variable
        #
        # Returns the Array of recording instances
        def all
          # Assign to an empty array if nil
          @@list ||= []
        end

        # Alias the .list method to .all
        alias_method :list, :all
        # Alias the .to_a method to .all
        alias_method :to_a, :all


        # Public: Returns an array of recording instances
        #
        # recordings - an Array of Hashes returned from a SOAP call
        #
        # Returns an Array of Recording instances
        def new_from_soap(recordings)
          # Reset the list array to be blank
          @@list = []
          recordings.map do |recording|
            @@list << self.new(recording)
          end
          self
        end

        # Public: Display information about the number of recordings available
        #
        # Returns a String
        def inspect
          "TranscribeMe::API::Recordings count=#{list.count} list=[...] "
        end

        # Alias .to_s to .inspect for convenience
        alias_method :to_s, :inspect


        # Public: Gets the list of completed recordings
        #
        # Returns an Array with only the recordings of status 50
        def completed
          list.select {|l| l[:status] == 50 }
        end

        # Public: Gets the list of in progress recordings
        #
        # Returns an Array with only the recordings of status 40
        def in_progress
          list.select {|l| l[:state] == 40 }
        end

        # Public: Gets the list of recordings currently processing audio
        #
        # Returns an Array with only the recordings of status 35
        def processing_audio
          list.select {|l| l[:state] == 35 }
        end

        # Public: Gets the list of recordings currently ready for transcription
        #
        # Returns an Array with only the recordings of status 10
        def ready_for_transcription
          list.select {|l| l[:state] == 10 }
        end

        # Alias :ready_for_transcription to :ready for convenience
        alias_method :ready, :ready_for_transcription

        # Public: Delegate methods we don't understand to the array
        #
        # method - a String or Symbol
        # *args  - optional variable arguments
        # &block - optional block
        #
        # Example:
        #
        #    Recording.each do |recording|
        #      puts recording[:name]
        #    end
        #
        # Returns the result of the delegated method call or
        #  raises a runtime error if the method isn't findable
        def method_missing(method, *args, &block)
          if list.respond_to? method.to_sym
            list.send(method.to_sym, *args, &block)
          else
            super
          end
        end

      end

    end
  end
end