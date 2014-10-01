class Publisher
	# test the publisher with the BunnyMock gem making sure that there is no problems publishing
	def self.publish(exchange, message = {})
		exchange = channel.fanout("project.#{exchange}")
		
		exchange.publish(message.to_json, :persistent => true)
	end

	
	def self.channel
		@channel ||= connection.create_channel
	end


	def self.connection
		@connection ||= BunnyMock.new.tap do |c|
			c.start
		end
	end
end
