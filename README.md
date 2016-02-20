# Linterbot

[![Gem Version](https://badge.fury.io/rb/linterbot.svg)](https://badge.fury.io/rb/linterbot)

A bot that parses [SwiftLint](https://github.com/realm/SwiftLint) output and analyzes a GitHub pull request. Then for each linter violation it will make comment in the pull request diff on the line where the violation was made.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'linterbot'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install linterbot

## Usage

Locally

```
swiftlint --reporter json | linterbot REPOSITORY PULL_REQUEST_NUMBER
```

In TravisCI

```
swiftlint --reporter json | linterbot $TRAVIS_REPO_SLUG $TRAVIS_PULL_REQUEST
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/guidomb/linterbot.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
