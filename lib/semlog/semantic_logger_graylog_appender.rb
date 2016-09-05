require "semantic_logger"

module Semlog

  class SemanticLogger::Appender::GelflogAppender < SemanticLogger::Subscriber

    # Map Semantic Logger levels to Graylog levels
    LEVEL_MAP = {
      fatal: Semlog::FATAL,
      error: Semlog::ERROR,
      warn: Semlog::WARN,
      info: Semlog::INFO,
      debug: Semlog::DEBUG,
      trace: Semlog::DEBUG
    }

    attr_reader :notifier

    def initialize(options = {}, &block)
      options = options.dup

      @rabbit_host=options.delete(:host)|| 'localhost'
      @port=options.delete(:port)|| 5672
      @vhost=options.delete(:vhost)||''
      @exchange=options.delete(:exchange)|| ''
      @user=options.delete(:user)||''
      @pw=options.delete(:pw)||''
      @app_name = options.delete(:application) || 'Semlog'

      super(options, &block)
      self.application = @app_name

      reopen
    end

    def reopen
      @notifier = RabbitNotifier.new(host: @rabbit_host, port: @port, vhost: @vhost, exchange_name: @exchange, user: @user, pw: @pw)
    end

    def make_hash(log)
      h = log.to_h(host, application)
      h[:level] = map_level(log)
      h[:level_str] = log.level.to_s
      h[:short_message] = h.delete(:message) if log.message && !h.key?("short_message") && !h.key?(:short_message)
      h[:request_uid] = h.delete(:tags).first if log.tags && log.tags.count > 0
      h
    end

    # Forward log messages
    def log(log)
      return false unless should_log?(log)

      begin
        @notifier.notify!(make_hash(log))
      rescue => e
        $logger.error "Semlog::Appender::GelflogAppender >EXCEPTION> #{e}"
      end

      true
    end

    # Returns the Graylog level for the supplied log message
    def map_level(log)
      LEVEL_MAP[log.level]
    end

  end
end
