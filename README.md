# Semlog

Gelf log appender directly to rabbitmq

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'semlog'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install semlog

## Usage

Suggested initializer
```ruby
$logger = SemanticLogger['semlog']
$logger.level = Logger.const_get(ENV.fetch("LOG_LEVEL", "INFO"))
SemanticLogger.add_appender(file_name: file_name, formatter: :color)
SemanticLogger.add_appender(io: $stderr, level: :debug)


gelf_appender = Semlog::SemanticLogger::Appender::GelflogAppender.new(
  host: ENV['RABBIT_HOST'],
  port: ENV['RABBIT_PORT'],
  vhost:ENV['RABBIT_VIRTUAL_HOST'],
  exchange: ENV['RABBIT_EXCHANGE'],
  user:  ENV['RABBIT_USER'],
  pw:  ENV['RABBIT_PW'],
  application: 'semlog'
)

gelf_appender.name = 'Semlog'


SemanticLogger.add_appender(gelf_appender)

$logger.info "Logging initiated to #{$logger.level } level"

```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Deploy

 gem build semlog
 gem push semlog-0.XXX.gem

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/leffen/semlog.

