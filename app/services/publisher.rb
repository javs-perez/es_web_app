class Publisher
	def initialize(connection, exchange, channel)
    @connection = self.class.connection
    @channel = self.class.create_channel(@session)
    @exchange = self.class.publish(@channel)
  end


	def self.publish(exchange, message = {})
		@exchange = channel.fanout("project.#{exchange}")

		@exchange.publish(message.to_json, :durable => true)
	end

	def self.channel
		@channel ||= connection.create_channel
	end

	def self.connection
		@connection ||= Bunny.new.tap do |c|
			c.start
		end
	end
end
