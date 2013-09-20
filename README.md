# TranscribeMe gem
[![Build Status](https://travis-ci.org/tuttinator/transcribeme.png?branch=master)](https://travis-ci.org/tuttinator/transcribeme)
[![Gem Version](https://badge.fury.io/rb/transcribeme.png)](http://badge.fury.io/rb/transcribeme)
[![Dependency Status](https://gemnasium.com/tuttinator/transcribeme.png)](https://gemnasium.com/tuttinator/transcribeme)
[![Coverage Status](https://coveralls.io/repos/tuttinator/transcribeme/badge.png)](https://coveralls.io/r/tuttinator/transcribeme)
[![Code Climate](https://codeclimate.com/github/tuttinator/transcribeme.png)](https://codeclimate.com/github/tuttinator/transcribeme)


### Description

This gem is a Ruby wrapper for the TranscribeMe SOAP API, built on Savon, and includes some extra dangly bits for uploading to Windows Azure Blob storage.

This gem wants to make it easy for you. It tries, at least. If you call the 'sign_in' method before initializing a session then we all know you meant to. We'll jump right in there and initialize it for you.

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

See [USAGE.md](USAGE.md)

## Documentation

Documentation follows [Tomdoc](http://tomdoc.org) and is generated by [YARD](http://yardoc.org)

The documentation can be [browsed online](http://rubydoc.info/github/tuttinator/transcribeme/master/frames)

## Changelog

Version 1.00

Initial stable release

Version 1.0.1

Bug fix - 

## Roadmap

Version 1.1.0


- [x] Set up Travis-CI and document supported Ruby versions

- [x] Investigate Windows Azure Blob storage file upload

- [x] Include Excon for Windows Azure Blob storage

- [x] Base64 decrypt transcription results

- [x] Document SOAP calls and error messages

- [x] Complete YARD documentation

- [x] Refactor the recordings array into an object with `.completed` `.in_progress` and `.ready_for_transcription` methods

- [x] Exceptions for error handling

- [x] Modelling Recording objects, particularly better describing recording status

- [ ] Reduce gem size through reducing spec support files (download as needed during specs, gitignored?)


Version 1.2.0


- [ ] Implement the customer sign up API

- [ ] Implement the customer reset password


Version 2.0.0

- [ ] Breaking changes planned: Refactor DSL around recordings to be more OO 


Version 2.1.0

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


