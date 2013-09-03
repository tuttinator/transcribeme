# TranscribeMe gem
[![Build Status](https://travis-ci.org/tuttinator/transcribeme.png?branch=master)](https://travis-ci.org/tuttinator/transcribeme)
[![Gem Version](https://badge.fury.io/rb/transcribeme.png)](http://badge.fury.io/rb/transcribeme)
[![Dependency Status](https://gemnasium.com/tuttinator/transcribeme.png)](https://gemnasium.com/tuttinator/transcribeme)
[![Coverage Status](https://coveralls.io/repos/tuttinator/transcribeme/badge.png)](https://coveralls.io/r/tuttinator/transcribeme)
[![Code Climate](https://codeclimate.com/github/tuttinator/transcribeme.png)](https://codeclimate.com/github/tuttinator/transcribeme)


### Description

This gem is a Ruby wrapper for the TranscribeMe SOAP API, built on Savon, and includes some extra dangly bits for uploading to Windows Azure Blob storage.

The DSL may change before 1.0.0 stable is released. 

Changes from prior 1.0.0 include bringing the Ruby method names in line with the actual SOAP action names.

This gem wants to make it easy for you. If you call the 'sign_in' method before initializing a session then we all know you meant to. We'll jump right in there and initialize it for you.

## Prerequisites

This gem relies on FFMPEG for determining the duration of audio (and video) files. The TranscribeMe SOAP API leaves it as the client's responsibility for determining the duration of files being uploaded.

## Installation

Add this line to your application's Gemfile:

    gem 'transcribeme'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install transcribeme

## Usage

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


## Documentation

Documentation follows [Tomdoc](http://tomdoc.org) and is generated by [YARD](http://yardoc.org)

The documentation can be [browsed online](http://rubydoc.info/github/tuttinator/transcribeme/master/frames)

## Roadmap

Version 1.0.0 stable

- [ ] Write specs
- [x] Set up Travis-CI and document supported Ruby versions
- [x] Investigate Windows Azure Blob storage file upload
- [x] Include Excon for Windows Azure Blob storage
- [x] Base64 decrypt transcription results
- [ ] Document SOAP calls and error messages
- [ ] Complete YARD documentation
- [ ] Include option (default)
- [ ] Validations for GUIDs 
- [ ] Exceptions for error handling (about 50%)
- [ ] Modelling Recording objects, particularly better describing recording status
- [ ] Reduce gem size through reducing spec support files (download as needed during specs, gitignored?)
- [ ] Implement the customer sign up API
- [ ] Implement the customer reset password

Version 1.1.0

- [ ] Refactor the recordings array into an object with `#completed` `#in_progress` and `#ready` instance methods

Version 1.2.0

- [ ] Create a CLI interface

RubyMotion

- [ ] A RubyMotion fork (transcribeme-motion), wrapped in BubbleWrap's HTTP DSL (watch this space)

REST API Wrapper

- [ ] A Sinatra RESTful wrapper around the SOAP operations for your own personal REST API middleman, with JSON-ic magic at your fingertips. JSON was always my favourite Argonaut.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


