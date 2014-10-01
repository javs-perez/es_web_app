class ProjectMessage < ActiveRecord::Base
	belongs_to :project

	# for ever project_message in the model it tries to publish it one more time, if successful it destroys the entry
	# if not successful it does nothing except for puts a message
	def self.publish_all
		self.all.each do |project_message|

			begin 
				Publisher.publish("projects", JSON.parse(project_message.message))
				project_message.destroy
			rescue Bunny::Exception
				puts "Please make sure rake publish_messages is run again when the server is available"
			end
		end
	end
end
