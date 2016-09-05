require 'bunny'
require 'oj'
require 'awesome_print'

Oj.default_options = {:mode => :compat}

module Semlog


  class RabbitNotifier

    attr_accessor :connection, :host, :port, :vhost, :exhange_name, :user, :pw, :default_options

    def initialize host:, port:, vhost:, exchange_name:, user:, pw:
      @connection = nil
      @host = host
      @port = port
      @vhost = vhost
      @exhange_name = exchange_name
      @user = user
      @pw = pw

      $logger.debug "RabbitNotifier>host: #{@host} port #{@port} vhost #{@vhost} "

      @default_options = {}
      @default_options['version'] = "1.1"
      @default_options['host'] ||= Socket.gethostname
      @default_options['level'] ||= Semlog::UNKNOWN
      @default_options['facility'] ||= 'RabbitNotifier'

    end

    def connect
      unless @connection
        @connection = Bunny.new(:host => @host, :vhost => @vhost, :user => @user, :password => @pw)
        @connection.start
      end
      @connection
    end

    def gelfify(data)
      gdata = @default_options.dup
      data.keys.each do |key|
        value, key_s = data[key], key.to_s
        if ['host', 'level', 'version', 'short_message', 'full_message', 'timestamp', 'facility', 'line', 'file'].index(key_s)
          gdata[key_s] = value
        elsif key_s == 'action'
          gdata["_application_action"] = value
        elsif key_s == 'id'
          gdata["_application_id"] = value
        elsif key_s[0] != '_'
          gdata["_#{key_s}"] = value
        else
          gdata[key_s] = value
        end
      end
      gdata
    end

    def data_to_json(data)
      Oj.dump(gelfify(data))
    end

    def notify!(data)
      exchange.publish(data_to_json(data))
    end

    def channel
      connect
      @channel ||= @connection.create_channel
    end

    def exchange
      @exchange ||= channel.fanout(exhange_name, durable: true)
    end
  end

end