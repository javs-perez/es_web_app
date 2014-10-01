class User < ActiveRecord::Base
	has_many :projects

	# validation of the phone # is done in a simple format of xxx-xxx-xxxx
	validates :phone, format: { with: /\d{3}-\d{3}-\d{4}/, message: "please use xxx-xxx-xxxx format"}
	# app will not be made to the public, validating the email by making sure it has a '@' in it should be enough
	validates :email, format: { with: /@/, message: "please enter a correct email address" }
	# need to make sure we know who the owner of the project is, name must be present
	validates :name, :presence => { :message => "Name cannot be blank" }
end
