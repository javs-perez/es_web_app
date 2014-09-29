class Publisher
	def self.publish(exchange, message = {})
		x = channel.fanout("project.#{exchange}")

		x.publish(message.to_json, :persistent => true)
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