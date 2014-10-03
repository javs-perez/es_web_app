class User < ActiveRecord::Base
	include Message
	has_many :projects

	# validation of the phone # is done in a simple format of xxx-xxx-xxxx
	validates :phone, format: { with: /\d{3}-\d{3}-\d{4}/, message: "please use xxx-xxx-xxxx format"}
	# app will not be made to the public, validating the email by making sure it has a '@' in it should be enough
	validates :email, format: { with: /@/, message: "please enter a correct email address" }
	# need to make sure we know who the owner of the project is, name must be present
	validates :name, :presence => { :message => "Name cannot be blank" }

	before_save :new_user?
  after_save :publish_new_user

	
	private

		def new_user?
   		if id 
   			@old_user = User.find_by(id: id)
   		end
  	end

		def publish_new_user
	  	@id 		= self.id
  		@email  = self.email
  		@name   = self.name
  		@phone  = self.phone

 			if @old_user == nil
  			set_message("welcome_user", @id, @email, @name, @phone)

      	# rescues an exception of the message cannot be delivered and saves the message to the database
      	# to be sent at a later time through a rake task
      	begin
        	Publisher.publish("projects", @message )
      	rescue Bunny::Exception 
        	project_messages.create!(message: @message.to_json)
      	end
    	end
  	end
end
