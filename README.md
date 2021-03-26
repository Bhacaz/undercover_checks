# UndercoverChecks

Send [Undercover](https://github.com/grodowski/undercover) report to a Pull Request Checks on Github.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'undercover_checks'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install undercover_checks

## Usage

### Prerequisites

See [Undercover](https://github.com/grodowski/undercover) installation guide.

### CLI

You would need a personal [Github App](https://docs.github.com/en/developers/apps) to use the CLI.

To use the CLI:

```shell
bundle exec undercover-checks \
 --repository <<repository>> \
 --sha <<commit sha>> \
 --app-id <<Github app id>> \
 --app-installation-id <<Github app installation id>> \
 --app-secret <<Github app secret>>
```

Two additional arguments are available:

```shell
--lcov <<path to lcov file>> \
--minimum-delta <<minimum coverage pass the check (integer)>>
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Bhacaz/undercover_checks.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
