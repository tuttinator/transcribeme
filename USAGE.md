# Usage

To get a file transcribed with this gem, this is the workflow:

- Sign in as a Customer
- Upload a file
- Submit for transcription (possibly with a Promocode)


#### Signing in

To create a new instance of the API client

    client = TranscribeMe::API::Client.new

API Sessions have a lifetime of 1 hour. When we sign in as a user an API session will be created if it is either no longer valid or not yet initialized.

    client.sign_in 'example@transcribeme.com', 'example'

GUIDs are prolific. Your session id is a GUID, and will be available in `client.session_id` but the result of signing in will return your Customer ID. Don't worry, you won't need this.

#### Getting a list of recordings

To get your recordings, call the `get_recordings` method:

    recordings = client.get_recordings

This will return an array of hashes. These hashes have the following keys: `:date_created`, `:duration`, `:id`, `:name` and `:status`.

TODO: Status is currently slightly cryptic, and this will improve.

    "10" # => Ready for transcription
    "40" # => In Progress
    "50" # => Complete

using `Array#select` you can filter for recordings that are in progress, complete or ready for transcription. This will be refactored post 1.0.0.

Array#select examples:

    completed   = recordings.select {|x| x[:status] == "50"}
    in_progress = recordings.select {|x| x[:status] == "40"}
    ready       = recordings.select {|x| x[:status] == "10"}

#### Uploading recordings

###### Prerequisites

NOTE: This piece of functionality (and actually only this) relies on FFMPEG and the `streamio-ffmpeg` Ruby gem, unless you explicitly state the duration of the audio in an options hash.

On Ubuntu:

    sudo apt-get install ffmpeg

(or your Linux package manager to install the ffmpeg package)

On Mac:

Get [Homebrew](http://brew.sh/) and then

    brew install ffmpeg


Not yet tested on Windows environments. Feel free to send feedback / advice on an FFMPEG alternative.


RubyMotion - this gem uses synchronous connections, and other stuff making it inappropriate. A RubyMotion-specific gem is in the works.

###### Actually uploading files

    client.upload 'my_cool_file.mp3'

That's pretty easy, right?

Or you can also include a second argument, to overwrite the defaults.

      # options   - a Hash with these keys:
      #             :multiple_speakers  - Boolean (default is true)
      #             :duration           - Float
      #             :description        - String

    client.upload 'my_cool_file.mp3', { duration: 12345.12, multiple_speakers: false, description: "Yo!" }

This can take some time, as it first uses [Excon](http://excon.io/) to upload to Windows Azure Blob Storage, using the URL asked provided by the API. Once the upload to Windows Azure completes, it sends a SOAP request to the API to confirm the file name and details. The recording is then in the initial state - Status 10, Ready for Transcription.

The return value is the response hash, which includes the Recording ID. This Recording ID is a GUID, and you may want to hold on to it. It will be available in the list of recordings.

#### Submitting recordings for transcription

If you have used the [web interface](https://portal.transcribeme.com) to set up payment you can use the transcribe_recording method like so:

    client.transcribe_recording '5e38e162-3e05-4f4d-82c1-010a34891fd8'

or if you have a promo code:

    client.transcribe_recording_using_promocode '5e38e162-3e05-4f4d-82c1-010a34891fd8', 'MyPromoCodeRules'
